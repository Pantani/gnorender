package gnorender

import (
	"testing"

	"gno.land/p/nt/uassert/v0"
)

func TestDrawPanel(t *testing.T) {
	got := DrawPanel("Transfer", "Escrow ready\nVoucher minted")

	uassert.Equal(t, `+----------------+
|    Transfer    |
+----------------+
| Escrow ready   |
| Voucher minted |
+----------------+`, got)
}
