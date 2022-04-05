module optimizer

fn (opt &Optimizer) trace_with_node<T>(ast_node &T) {
	$if trace_optimizer ? {
		ntype := typeof(ast_node).replace('v.ast.', '')
		eprintln('optimize: ${opt.file.path:-30} | pos: ${node.pos.line_str():-39} | node: $ntype | $node')
	}
}

fn (opt &Optimizer) trace_with_msg(msg &string) {
	$if trace_optimizer ? {
		eprintln(msg)
	}
}
