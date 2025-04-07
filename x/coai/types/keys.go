package types

const (
	// ModuleName defines the module name
	ModuleName = "coai"

	// StoreKey defines the primary module store key
	StoreKey = ModuleName

	// MemStoreKey defines the in-memory store key
	MemStoreKey = "mem_coai"
)

var (
	ParamsKey = []byte("p_coai")
)

func KeyPrefix(p string) []byte {
	return []byte(p)
}
