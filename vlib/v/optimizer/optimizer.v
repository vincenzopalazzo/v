module optimizer

import v.ast

[heap]
struct Optimizer {
pub mut:
	table     &ast.Table // aka Symble Table.
	curr_file &ast.File = 0 // current file under optimization.
}

// new_optimizer create a new instance of the optimizer
pub fn new_optimizer(table &ast.Table) &Optimizer {
	return &Optimizer{
		table: table
	}
}

fn (mut opt Optimizer) change_current_file(new_curr &ast.File) {
	opt.curr_file = unsafe { new_curr }
	opt.trace_with_msg('changing current file ${new_curr.path}')
}

pub fn (mut opt Optimizer) optimize_files(ast_files []&ast.File) {
	for i in 0 .. ast_files.len {
		mut file := unsafe { ast_files[i] }
		opt.optimize(file)
	}
}

// optimize perform optimization on the correct AST
fn (mut opt Optimizer) optimize(ast_file &ast.File) {
	opt.change_current_file(ast_file)
	for i in 0 .. ast_file.stmts.len {
		mut stm := unsafe { ast_file.stmts[i] }
		opt.stmt(&stm)
	}
}

// FIXME: the ast_node should be & and not a copy, this for now
// cause a huge leak
fn (mut opt Optimizer) stmt(ast_node &ast.Stmt) {
	mut node := unsafe { ast_node }
	opt.trace_with_node(node)
}
