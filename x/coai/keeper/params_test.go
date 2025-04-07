package keeper_test

import (
	"testing"

	"github.com/stretchr/testify/require"

	keepertest "github.com/myuser/CoAI/testutil/keeper"
	"github.com/myuser/CoAI/x/coai/types"
)

func TestGetParams(t *testing.T) {
	k, ctx := keepertest.CoaiKeeper(t)
	params := types.DefaultParams()

	require.NoError(t, k.SetParams(ctx, params))
	require.EqualValues(t, params, k.GetParams(ctx))
}
