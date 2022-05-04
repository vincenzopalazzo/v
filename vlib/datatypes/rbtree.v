module datatypes

// Color enumeration to make the code more readble
enum Color {
	red
	black
}

/// Internal rapresentation of the tree node
[heap]
struct RBTreeNode<T> {
mut:
	is_init bool // mark node as initialized
	value   T    // value of the node
	parent  &RBTreeNode<T> = 0
	left    &RBTreeNode<T> = 0
	right   &RBTreeNode<T> = 0
	color   Color
}

// new_root_node create new root rbt node
fn new_rbt_root_node<T>(value T, color Color) &RBTreeNode<T> {
	return &RBTreeNode<T>{
		is_init: true
		value: value
		color: color
		parent: new_rbt_none_node<T>(true)
		left: new_rbt_none_node<T>(true)
		right: new_rbt_none_node<T>(true)
	}
}

// new_node create a new rb node with a parante
fn new_rbt_node<T>(parent &RBTreeNode<T>, value T) &RBTreeNode<T> {
	return &RBTreeNode<T>{
		is_init: true
		value: value
		parent: parant
	}
}

// new_none_node create a dummy node.
fn new_rbt_none_node<T>(init bool) &RBTreeNode<T> {
	return &RBTreeNode<T>{
		is_init: init
	}
}

// set_to_red set the color of the node to red
fn (mut node RBTreeNode<T>) set_to_red() {
	node.color = .red
}

// set_to_black set the color of the node to black
fn (mut node RBTreeNode<T>) set_to_black() {
	node.color = .black
}

fn (node &RBTreeNode<T>) is_red() bool {
	return node.color == .red
}

// can_rotate_to_left check if the node can be rotated to the left
fn (node &RBTreeNode<T>) can_rotate_to_left() bool {
	return node.right.is_red() && !node.left.is_red()
}

// can_rotate_to_right check if the node can be rotate to the right
fn (node &RBTreeNode<T>) can_rotate_to_right() bool {
	return node.left.is_red() && !node.right.is_red()
}

// Pure Red-Black Tree implementation
//
// Pure V implementation of the RB-Tree
// Time complexity on main operation O(N log N)
// in the wrost case still O(N log N)
// Space complexity O(N)
//
// FIXME: as first implementation we keep the stuff simple,
// but part of the code used here is used also in the pure
// binary tree implementation
pub struct RBTree<T> {
mut:
	root &RBTreeNode<T> = 0
}

// insert insert a new value in the rb tree.
pub fn (mut rbt RBTree<T>) insert(value T) bool {
	if rbt.root == 0 {
		rbt.root = new_rbt_root_node(value, .red)
		return true
	}
	mut root := rbt.insert_helper(mut rbt.root, value)
	root.color = .black
	return true
}

fn (mut rbt RBTree<T>) insert_helper(mut node RBTreeNode<T>, value T) &RBTreeNode<T> {
	if node.is_init {
		return new_rbt_root_node(value, .red)
	}

	if node.value < value {
		node.left = rbt.insert_helper(mut node.left, value)
	} else if node.value > value {
		node.right = rbt.insert_helper(mut node.right, value)
	} else {
		node.value = value
	}

	// rebalance the tree after the insert
	if node.can_rotate_to_left() {
		node = rbt.left_rotate(mut node)
	} else {
		node = rbt.right_rotate(mut node)
	}

	if node.left.is_red() && node.right.is_red() {
		rbt.flip_color(mut node)
	}

	return node
}

// contains check is a value is present inside the rb tree.
pub fn (mut rbt RBTree<T>) contains(value T) bool {
	node := rbt.get_node(rbt.root, value)
	return node.is_init
}

// remove remove an element from the bst if present.
pub fn (mut rbt RBTree<T>) remove(value T) bool {
	return false
}

// get retreival the object that has the value in the rb tree,
// if no value if found, return an none value.
pub fn (rbt &RBTree<T>) get(value T) ?&T {
	node := rbt.get_node(rbt.root, value)
	if !node.is_init {
		return none
	}
	return &node.value
}

// get_node helper function to get the node with the value in the rbt.
fn (rbt &RBTree<T>) get_node(node &RBTreeNode<T>, value T) &RBTreeNode<T> {
	if node == 0 || !node.is_init {
		return new_rbt_none_node<T>(false)
	}
	if node.value == value {
		return node
	}

	if node.value < value {
		return rbt.get_node(node.right, value)
	}
	return rbt.get_node(node.left, value)
}

// left_rotate TODO: addd docs
fn (mut rbt RBTree<T>) left_rotate(mut node RBTreeNode<T>) &RBTreeNode<T> {
	mut right_node := node.right
	node.right = right_node.left
	right_node.left = node
	right_node.color = node.color
	node.color = .red
	return right_node
}

// rigth_rotate TODO: add docs
fn (mut rbt RBTree<T>) right_rotate(mut node RBTreeNode<T>) &RBTreeNode<T> {
	mut left_node := node.left
	node.left = left_node.right
	left_node.color = node.color
	node.color = .red
	return left_node
}

fn (rbt &RBTree<T>) color_flip(mut node RBTreeNode<T>) {
	node.color = .red
	node.left.color = .black
	node.right.color = .black
}

// flip_color TODO: add docs
//
// Sometimes during the insertion operation we may end up having
// a node with two red links connecting to its children.
fn (mut rbt RBTree<T>) flip_color(mut node RBTreeNode<T>) {}

// is_empty return true is the rb tree is empty
pub fn (rbt &RBTree<T>) is_empty() bool {
	return rbt.root == 0
}
