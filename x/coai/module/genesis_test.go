package coai_test

import (
	"testing"

	keepertest "github.com/myuser/CoAI/testutil/keeper"
	"github.com/myuser/CoAI/testutil/nullify"
	coai "github.com/myuser/CoAI/x/coai/module"
	"github.com/myuser/CoAI/x/coai/types"
	"github.com/stretchr/testify/require"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		Params: types.DefaultParams(),

		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.CoaiKeeper(t)
	coai.InitGenesis(ctx, k, genesisState)
	got := coai.ExportGenesis(ctx, k)
	require.NotNil(t, got)

	nullify.Fill(&genesisState)
	nullify.Fill(got)

	// this line is used by starport scaffolding # genesis/test/assert
}
