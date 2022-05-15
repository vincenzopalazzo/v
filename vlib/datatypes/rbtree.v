module datatypes

// Color enumeration
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
		parent: new_rbt_none_node<T>(false)
	}
}

// new_node create a new rb node with a parante
fn new_rbt_node<T>(parent &RBTreeNode<T>, value T) &RBTreeNode<T> {
	return &RBTreeNode<T>{
		is_init: true
		value: value
		parent: parent
		color: .red
	}
}

// new_none_node create a dummy node.
fn new_rbt_none_node<T>(init bool) &RBTreeNode<T> {
	return &RBTreeNode<T>{
		is_init: init
		color: .red
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

fn (node &RBTreeNode<T>) is_left_red() bool {
	return node.is_init && node.left.is_init && node.left.is_red()
}

fn (node &RBTreeNode<T>) is_right_red() bool {
	return node.is_init && node.right.is_init && node.right.is_red()
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
	result := rbt.insert_helper(mut rbt.root, value)
	if result {
		rbt.root.color = .black
		return result
	}
	return false
}

fn (mut rbt RBTree<T>) insert_helper(mut node RBTreeNode<T>, value T) bool {
	mut root := node
	mut target := new_rbt_none_node<T>(false)
	for node.is_init {
		unsafe {
			*target = root
			if value < root.value {
				root = root.left
			} else {
				root = root.right
			}
		}
	}
	mut node_value := new_rbt_node<T>(target, value)
	if !target.is_init {
		rbt.root = node_value
	} else if node_value.value < target.value {
		target.left = node_value
	} else {
		target.right = node_value
	}

	if node_value.parent == 0 || !node_value.is_init {
		node_value.color = .red
		return true
	}

	if node_value.parent.parent == 0 || !node_value.is_init {
		return true
	}

	// FIXME: check the parent if is non
	// FIXME: check the parent of the parent if is none
	return rbt.insert_fixup(mut node_value)
}

fn (mut rbt RBTree<T>) insert_fixup(mut node RBTreeNode<T>) bool {
	for node.parent.is_red() {
		if node.parent == node.parent.parent.left {
			targert_right := node.parent.parent.right
		} else {
			target_left := node.parent.parent.left
		}
	}
	return true
}

// contains check is a value is present inside the rb tree.
pub fn (mut rbt RBTree<T>) contains(value T) bool {
	node := rbt.get_node(rbt.root, value)
	return node.is_init
}

// remove remove an element from the bst if present.
pub fn (mut rbt RBTree<T>) remove(value T) bool {
	if rbt.is_empty() {
		return false
	}
	return rbt.remove_helper(mut rbt.root, value)
}

fn (mut rbt RBTree<T>) remove_helper(mut node RBTreeNode<T>, value T) bool {
	if !node.is_init {
		return false
	}

	mut target := rbt.get_node(node, value)
	if !target.is_init {
		return false
	}
	mut new_node := new_rbt_none_node<T>(false)
	mut target_color := target.color
	if !target.left.is_init {
		new_node = target.right
		rbt.transplant(mut target, mut target.right)
	} else if !target.right.is_init {
		new_node = target.left
		rbt.transplant(mut target, mut target.left)
	} else {
		// placeholder, find the minimum
		mut local_min := rbt.get_min(target.right)
		target_color = local_min.color
		if local_min.parent == target {
			new_node.parent = target
		} else {
			rbt.transplant(mut local_min, mut local_min.right)
			local_min.right = target.right
			local_min.right.parent = local_min
		}
		rbt.transplant(mut target, mut local_min)
		local_min.left = target.left
		local_min.left.parent = local_min
		local_min.color = target.color
	}
	if target_color == .black {
		return rbt.fixup(mut new_node)
	}
	return true
}

// transpant reorganize the subtree when the parent is deleted
fn (mut rbt RBTree<T>) transplant(mut node_u RBTreeNode<T>, mut node_v RBTreeNode<T>) bool {
	if !node_u.parent.is_init {
		// remove the root
		rbt.root = node_v
		return true
	}

	if node_u == node_u.parent.left {
		node_u.parent.left = node_v
	} else if node_u == node_u.parent.right {
		node_u.parent.right = node_v
	}
	// FIXME: we need to manually free node_u?
	node_v.parent = node_u.parent
	return true
}

// fixup restore the red black tree proprieties.
//
// RB-Proprieties:
// Case 1: TODO
// Case 2: TODO
// Case 3: TODO
// Case 4: TODO
fn (mut rbt RBTree<T>) fixup(mut node RBTreeNode<T>) bool {
	mut target := node
	for target != rbt.root && target.color == .black {
		// we panic in this case and it is totally fine,
		// because should be a not expected error, but
		// for the first release cycle we keep this as "sanity check"
		if target == target.parent.left {
			mut target_right := target.parent.right
			target = *rbt.fixup_branch(mut target, mut target_right) or { panic(err) }
		} else {
			mut target_left := target.parent.left
			target = *rbt.fixup_branch(mut target, mut target_left) or { panic(err) }
		}
	}
	return true
}

// TODO: add well documentation because will be tricky for other to catch some bugs in the future
fn (mut rbt RBTree<T>) fixup_branch(mut parent RBTreeNode<T>, mut node RBTreeNode<T>) !&RBTreeNode<T> {
	// case 1
	if node.color == .red {
		node.color = .black
		parent.parent.color = .red
		rbt.left_rotate(mut parent.parent)
		return parent.parent.right
	}
	if !node.left.is_red() && !node.right.is_red() {
		// case 2
		node.color = .red
		return parent.parent
	} else if !node.is_red() {
		// case 3
		node.left.color = .black
		node.color = .red
		rbt.right_rotate(mut node)
		node.color = parent.parent.color
		node.right.color = .black
		rbt.left_rotate(mut parent.parent)
		return rbt.root
	}
	return error('implementation error uring the balance procedure, please report the bug')
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

// get_min return the leaf node to the left of the node as parameter
fn (rbt &RBTree<T>) get_min(node &RBTreeNode<T>) &RBTreeNode<T> {
	if node.is_init {
		return node
	}
	return rbt.get_min(node.left)
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
fn (mut rbt RBTree<T>) flip_color(mut node RBTreeNode<T>) {
	node.color = .red
	node.left.color = .black
	node.right.color = .black
}

// is_empty return true is the rb tree is empty
pub fn (rbt &RBTree<T>) is_empty() bool {
	return rbt.root == 0
}
