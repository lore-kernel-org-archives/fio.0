Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:42674 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753502AbdGUXKG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2017 19:10:06 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: Number of Significant Figures
Date: Fri, 21 Jul 2017 23:09:20 +0000
Message-ID: <CY1PR0401MB1466818EED73F47951D660798FA40@CY1PR0401MB1466.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: multipart/mixed;
        boundary="_002_CY1PR0401MB1466818EED73F47951D660798FA40CY1PR0401MB1466_"
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

--_002_CY1PR0401MB1466818EED73F47951D660798FA40CY1PR0401MB1466_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi All,
In commit d694a6a7c02f577b2bb5d0ad24331b775acf6869 the reported IOPs change=
d from 6 significant figures to 4 significant figures.  So a fio summary fi=
le may change from 12345 IOPs to 12.3k IOPs.  The attached patch will resto=
re the original 6 significant figures (or maxlen in num2str.c).

Regards,
Jeff


--_002_CY1PR0401MB1466818EED73F47951D660798FA40CY1PR0401MB1466_
Content-Type: application/octet-stream; name="sig_figs.patch"
Content-Description: sig_figs.patch
Content-Disposition: attachment; filename="sig_figs.patch"; size=1457;
	creation-date="Fri, 21 Jul 2017 23:06:28 GMT";
	modification-date="Fri, 21 Jul 2017 23:06:28 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2djbGllbnQuYyBiL2djbGllbnQuYwppbmRleCA0ZWI5OWEwLi45NDcxZTll
IDEwMDY0NAotLS0gYS9nY2xpZW50LmMKKysrIGIvZ2NsaWVudC5jCkBAIC0xMTc5LDcgKzExNzks
NyBAQCBzdGF0aWMgdm9pZCBnZmlvX3Nob3dfZGRpcl9zdGF0dXMoc3RydWN0IGdmaW9fY2xpZW50
ICpnYywgR3RrV2lkZ2V0ICptYm94LAogCWJ3ID0gKDEwMDAgKiB0cy0+aW9fYnl0ZXNbZGRpcl0p
IC8gcnVudDsKIAogCWlvcHMgPSAoMTAwMCAqICh1aW50NjRfdCl0cy0+dG90YWxfaW9fdVtkZGly
XSkgLyBydW50OwotCWlvcHNfcCA9IG51bTJzdHIoaW9wcywgNCwgMSwgMCwgTjJTX1BFUlNFQyk7
CisJaW9wc19wID0gbnVtMnN0cihpb3BzLCA2LCAxLCAwLCBOMlNfUEVSU0VDKTsKIAogCWJveCA9
IGd0a19oYm94X25ldyhGQUxTRSwgMyk7CiAJZ3RrX2JveF9wYWNrX3N0YXJ0KEdUS19CT1gobWJv
eCksIGJveCwgVFJVRSwgRkFMU0UsIDMpOwpkaWZmIC0tZ2l0IGEvc3RhdC5jIGIvc3RhdC5jCmlu
ZGV4IGFlYmQxMDcuLjYyOTkyNWEgMTAwNjQ0Ci0tLSBhL3N0YXQuYworKysgYi9zdGF0LmMKQEAg
LTQzNyw3ICs0MzcsNyBAQCBzdGF0aWMgdm9pZCBzaG93X2RkaXJfc3RhdHVzKHN0cnVjdCBncm91
cF9ydW5fc3RhdHMgKnJzLCBzdHJ1Y3QgdGhyZWFkX3N0YXQgKnRzLAogCWJ3X3BfYWx0ID0gbnVt
MnN0cihidywgNCwgMSwgIWkycCwgdHMtPnVuaXRfYmFzZSk7CiAKIAlpb3BzID0gKDEwMDAgKiAo
dWludDY0X3QpdHMtPnRvdGFsX2lvX3VbZGRpcl0pIC8gcnVudDsKLQlpb3BzX3AgPSBudW0yc3Ry
KGlvcHMsIDQsIDEsIDAsIE4yU19OT05FKTsKKwlpb3BzX3AgPSBudW0yc3RyKGlvcHMsIDYsIDEs
IDAsIE4yU19OT05FKTsKIAogCWxvZ19idWYob3V0LCAiICAlczogSU9QUz0lcywgQlc9JXMgKCVz
KSglcy8lbGx1bXNlYylcbiIsCiAJCQlycy0+dW5pZmllZF9yd19yZXAgPyAibWl4ZWQiIDogc3Ry
W2RkaXJdLApAQCAtNzM1LDcgKzczNSw3IEBAIHN0YXRpYyB2b2lkIHNob3dfc3Nfbm9ybWFsKHN0
cnVjdCB0aHJlYWRfc3RhdCAqdHMsIHN0cnVjdCBidWZfb3V0cHV0ICpvdXQpCiAKIAlwMSA9IG51
bTJzdHIoYndfbWVhbiAvIHRzLT5rYl9iYXNlLCA0LCB0cy0+a2JfYmFzZSwgaTJwLCB0cy0+dW5p
dF9iYXNlKTsKIAlwMWFsdCA9IG51bTJzdHIoYndfbWVhbiAvIHRzLT5rYl9iYXNlLCA0LCB0cy0+
a2JfYmFzZSwgIWkycCwgdHMtPnVuaXRfYmFzZSk7Ci0JcDIgPSBudW0yc3RyKGlvcHNfbWVhbiwg
NCwgMSwgMCwgTjJTX05PTkUpOworCXAyID0gbnVtMnN0cihpb3BzX21lYW4sIDYsIDEsIDAsIE4y
U19OT05FKTsKIAogCWxvZ19idWYob3V0LCAiICBzdGVhZHlzdGF0ZSAgOiBhdHRhaW5lZD0lcywg
Ync9JXMgKCVzKSwgaW9wcz0lcywgJXMlcz0lLjNmJXNcbiIsCiAJCXRzLT5zc19zdGF0ZSAmIF9f
RklPX1NTX0FUVEFJTkVEID8gInllcyIgOiAibm8iLAo=

--_002_CY1PR0401MB1466818EED73F47951D660798FA40CY1PR0401MB1466_--
