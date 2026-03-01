#!/usr/bin/env python3
"""
Trim wav2vec2 ONNX model: remove CTC head (lm_head), expose hidden state.

Input:  wav2vec2_korean_q8.onnx          (~356MB, output: logits [1, T, 1205])
Output: wav2vec2_korean_emb_q8.onnx      (~335MB, output: hidden_state [1, T, 1024])

The CTC head (lm_head) has 1205 classes that don't match our 46 jamo labels.
Instead of trying to fix label mapping, we extract the 1024-dim hidden state
embeddings and use cosine similarity with TTS-generated reference embeddings.

Usage:
    python3 scripts/models/trim_wav2vec2.py

    # Custom paths:
    python3 scripts/models/trim_wav2vec2.py \
        --input  mobile/lemon_korean/assets/models/gop/wav2vec2_korean_q8.onnx \
        --output mobile/lemon_korean/assets/models/gop/wav2vec2_korean_emb_q8.onnx
"""

import argparse
import os
import sys

import onnx
from onnx import TensorProto, helper


def trim_model(input_path: str, output_path: str) -> None:
    print(f"Loading model: {input_path}")
    model = onnx.load(input_path)
    graph = model.graph

    input_size_mb = os.path.getsize(input_path) / 1024 / 1024
    print(f"  Input size: {input_size_mb:.1f} MB")
    print(f"  Original outputs: {[o.name for o in graph.output]}")

    # Target: last encoder layer norm output = hidden state [1, T, 1024]
    target_output = "/wav2vec2/encoder/layer_norm/LayerNormalization_output_0"

    # Verify target node exists
    found = False
    for vi in graph.value_info:
        if vi.name == target_output:
            dims = [d.dim_value for d in vi.type.tensor_type.shape.dim]
            print(f"  Target node found: {target_output}, shape={dims}")
            found = True
            break

    if not found:
        # Check in node outputs
        for node in graph.node:
            if target_output in node.output:
                found = True
                print(f"  Target node found in: {node.name}")
                break

    if not found:
        print(f"ERROR: Target output '{target_output}' not found in model")
        sys.exit(1)

    # Create new output with proper type info
    new_output = helper.make_tensor_value_info(
        "hidden_state", TensorProto.FLOAT, [1, None, 1024]
    )

    # Collect nodes that feed into the target output (encoder + feature extractor)
    # and remove nodes that only feed into lm_head
    needed_outputs = {target_output}
    needed_nodes = set()

    # BFS backward from target output to find all required nodes
    output_to_node = {}
    for i, node in enumerate(graph.node):
        for out in node.output:
            output_to_node[out] = i

    queue = [target_output]
    visited = set()
    while queue:
        tensor_name = queue.pop(0)
        if tensor_name in visited:
            continue
        visited.add(tensor_name)
        if tensor_name in output_to_node:
            node_idx = output_to_node[tensor_name]
            needed_nodes.add(node_idx)
            for inp in graph.node[node_idx].input:
                queue.append(inp)

    print(f"  Total nodes: {len(graph.node)}, needed: {len(needed_nodes)}")
    removed_count = len(graph.node) - len(needed_nodes)
    print(f"  Removing {removed_count} nodes (lm_head / unused)")

    # Filter nodes
    new_nodes = [graph.node[i] for i in sorted(needed_nodes)]

    # Rename the target tensor to "hidden_state" in the last node's output
    for node in new_nodes:
        new_outputs = []
        for out in node.output:
            if out == target_output:
                new_outputs.append("hidden_state")
            else:
                new_outputs.append(out)
        del node.output[:]
        node.output.extend(new_outputs)

    # Also rename in value_info references
    # (not strictly necessary since we're making new graph)

    # Collect needed initializers
    needed_initializer_names = set()
    for node in new_nodes:
        for inp in node.input:
            needed_initializer_names.add(inp)

    new_initializers = [
        init for init in graph.initializer if init.name in needed_initializer_names
    ]
    print(
        f"  Initializers: {len(graph.initializer)} -> {len(new_initializers)}"
    )

    # Build new graph
    new_graph = helper.make_graph(
        nodes=new_nodes,
        name="wav2vec2_embedding",
        inputs=list(graph.input),
        outputs=[new_output],
        initializer=new_initializers,
    )

    # Preserve value_info for intermediate tensors (needed for shape inference)
    needed_value_info = []
    for vi in graph.value_info:
        if vi.name != target_output:
            needed_value_info.append(vi)
    new_graph.value_info.extend(needed_value_info)

    # Build new model
    new_model = helper.make_model(new_graph, opset_imports=model.opset_import)
    new_model.ir_version = model.ir_version

    # Save
    print(f"Saving trimmed model: {output_path}")
    onnx.save(new_model, output_path)

    output_size_mb = os.path.getsize(output_path) / 1024 / 1024
    saved_mb = input_size_mb - output_size_mb
    print(f"  Output size: {output_size_mb:.1f} MB (saved {saved_mb:.1f} MB)")
    print("Done.")


def main():
    parser = argparse.ArgumentParser(
        description="Trim wav2vec2 ONNX: remove CTC head, expose hidden state"
    )
    parser.add_argument(
        "--input",
        default="mobile/lemon_korean/assets/models/gop/wav2vec2_korean_q8.onnx",
        help="Input ONNX model path",
    )
    parser.add_argument(
        "--output",
        default="mobile/lemon_korean/assets/models/gop/wav2vec2_korean_emb_q8.onnx",
        help="Output trimmed ONNX model path",
    )
    args = parser.parse_args()

    # Resolve paths relative to project root
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, "..", ".."))

    input_path = (
        args.input
        if os.path.isabs(args.input)
        else os.path.join(project_root, args.input)
    )
    output_path = (
        args.output
        if os.path.isabs(args.output)
        else os.path.join(project_root, args.output)
    )

    if not os.path.exists(input_path):
        print(f"ERROR: Input model not found: {input_path}")
        sys.exit(1)

    trim_model(input_path, output_path)


if __name__ == "__main__":
    main()
