
primWrite: id
	"Write up to count elements from the given buffer and answer the number of elements actually written. The buffer may either a byte- or word-indexable object."

	<primitive: 'primitiveFileWrite' module: 'FilePlugin'>
	self primitiveFailed