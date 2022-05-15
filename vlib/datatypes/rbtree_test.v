module datatypes

fn test_init_rbtree() {
	rbtree := RBTree<int>{}
	assert rbtree.is_empty()
}

fn test_insert_into_rbtree() {
	mut rbtree := RBTree<int>{}
	assert rbtree.insert(12)
	assert rbtree.insert(23)
	assert rbtree.insert(45)

	assert rbtree.contains(12)
	assert rbtree.contains(34) == false
}

fn test_remove_into_rbtree() {
	mut rbtree := RBTree<int>{}
	assert rbtree.insert(12)
	assert rbtree.insert(23)
	assert rbtree.insert(45)
	assert rbtree.insert(34)
	assert rbtree.contains(12)
	assert rbtree.contains(34)

	assert rbtree.remove(34)
	assert rbtree.contains(34) == false
}
