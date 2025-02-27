Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C0821D3C9
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639827; cv=none; b=LhqF46dG4DgBxAzSZN/0V5x46pp7JczlKhImlEtzNM0o6GuJuZ3qyeQBz0ATHPh8UtI1sx6FQWdZF7zEQK96cIbApb3TAawhCGF6KYMpu+9Y4+1dn49YPGR0qPPGAgj+lrCMDVqZ/m9crX+doJUCxRHkCxihiLWj/dM1z+gy4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639827; c=relaxed/simple;
	bh=YarxK4RgaKbaJ6CgjbKaDH9ETVDEP4ErZ6gF7Xt5Keg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=j1BtnL22WEEw5eYwHjKpp7dQomnJaMwCp5M4pbiDsxVrgRBekLwkVC50NPuk1t5G9dqs4dvtPu/WFdO186foc3eG3eg89rGXgZOOxxesop5IOxhNqBxrWQ5o9AYE5du/pE6oxE6uQbCdFLboW3UjlJCkyoee74gm9M72x4lEE8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZI+a4VXv; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZI+a4VXv"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250227070336epoutp0480eb0c30143143b46d856f3dd46ad028~n-rDwsgDp2254922549epoutp04d
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250227070336epoutp0480eb0c30143143b46d856f3dd46ad028~n-rDwsgDp2254922549epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639816;
	bh=/ChxtnyTD8saNXCMMlP94LU6DTJQU3ey8gxSF+F/M0s=;
	h=From:To:Cc:Subject:Date:References:From;
	b=ZI+a4VXvsGU6LndN8O4gNku15msgKoDEnKcYTsaXevz0tWF+vFbQ6auzpNesAz3Ef
	 3r0I1b0/Cy+Z48xDjqNaB56fiaiAKbl0Atzde895OhLeq2TYStcWhVj5jZ6aPXjRVi
	 OQmPR1GMGQfVpwW5MmK7rBOWh3rN0FyqpxdHlYlw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250227070336epcas5p1cd1141a2cbef27f52e8cf99c540374c4~n-rDgye650319303193epcas5p16;
	Thu, 27 Feb 2025 07:03:36 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Z3MkY52TQz4x9QG; Thu, 27 Feb
	2025 07:03:33 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	29.92.19710.24E00C76; Thu, 27 Feb 2025 16:03:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250227053350epcas5p31b3b5b47590d70804dade59842d87b27~n_crArQ390147701477epcas5p35;
	Thu, 27 Feb 2025 05:33:50 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053350epsmtrp20c1ee4c356d0dfbeee01936206a3f296~n_crAE6P52879728797epsmtrp2f;
	Thu, 27 Feb 2025 05:33:50 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-e6-67c00e4248bc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	46.4A.18949.E39FFB76; Thu, 27 Feb 2025 14:33:50 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053349epsmtip21ea49f56caa5cb509d96d337a8a0f088~n_cqTtjG61753617536epsmtip2U;
	Thu, 27 Feb 2025 05:33:49 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 00/21] verify fixes and a new test suite
Date: Thu, 27 Feb 2025 16:17:06 +0530
Message-Id: <20250227104727.1794982-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsWy7bCmhq4T34F0g1vTjSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOuLJ8IWPBJYmK4ys/szQwbhbqYuTk
	kBAwkVg6dytjFyMXh5DAbkaJ7xtamCCcT0DOjdlQmW+MEsfuLGOHaZnQvpcZIrGXUeLhoUlQ
	VT8YJa59m8IEUsUmoC3x6u0NoCoODhEBDYk1d1NBwswCdhJXD79kA7GFBSwkdr6/ywxiswio
	ShzrXcwCUs4LVPOjkQ1il7zEzEvfwfbyCghKnJz5hAVijLxE89bZYDdICGxjl+jdtwCqwUXi
	48FtrBC2sMSr41ugjpaS+PxuL1RNtsSmhz+ZIOwCiSMvepkhbHuJ1lP9YCczC2hKrN+lDxGW
	lZh6ah0TxF4+id7fT6BaeSV2zIOxVSX+3rvNAmFLS9x8dxXK9pDYdWMm2AlCArESa7uWs0xg
	lJ+F5J1ZSN6ZhbB5ASPzKkbJ1ILi3PTUZNMCw7zUcni8JufnbmIEJzstlx2MN+b/0zvEyMTB
	eIhRgoNZSYSXM3NPuhBvSmJlVWpRfnxRaU5q8SFGU2AQT2SWEk3OB6bbvJJ4QxNLAxMzMzMT
	S2MzQyVx3uadLelCAumJJanZqakFqUUwfUwcnFINTNduRlfVHDgfU9Fr2lh88uO/bdosn8/5
	sd3gdZ7+ceOyZbLyvB8Xi2isPGW12r9sx6VI3ZNifL5HuY9flM7hiJrb3/d5s8MWjsh58gvk
	u9MEbFewfJgQN23B34TzDIEhhx5FBqe/Y7/Fp+FVIt3m59Z09OchjsqFKhLJYcH5Ud3TS+Zp
	HOvVXLtaNrrl95x1f9dcfnI97NuEwIpJnoX3PzP1rj1hXuMx1ZrjGrfJGnupla9rvp4wS9zf
	/UPfUiXu9t8t55TLdkb9ri7jmOVS3vzvwe/ZjWl3Lz14NEPuA+urqesOZr1+fMPslCtfOe/0
	xctlnjSnrV9YzL3uQcdRboUjDzd/Pi50fMHRHP/lV1OVWIozEg21mIuKEwHpzva//wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsWy7bCSvK7dz/3pBtOOc1qsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVxZflCxoJL
	EhXHV35maWDcLNTFyMkhIWAiMaF9L3MXIxeHkMBuRok7F/cwdTFyACWkJRauT4SoEZZY+e85
	O0TNN0aJXXMes4Ik2AS0JV69vcEMYosIaEkcW9fEBmIzCzhI/Nu1BcwWFrCQ2Pn+LlgNi4Cq
	xLHexSwg83kF7CR+NLJBzJeXmHnpOzuIzSsgKHFy5hMWiDHyEs1bZzNPYOSbhSQ1C0lqASPT
	KkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4LDT0trBuGfVB71DjEwcjIcYJTiYlUR4
	OTP3pAvxpiRWVqUW5ccXleakFh9ilOZgURLn/fa6N0VIID2xJDU7NbUgtQgmy8TBKdXAVLY5
	MJt/+u07HxhvHrxufKK0TE13TpFf+hOVJUcO6LzgZrnkeNg74qX8stXt843CpAwPzwu3+Vmz
	/uZM8drC17saWN05dJO8j6j2v5C9GvJr/4SV32ZNXDe5ZndrczvjeT9Fi6B709YdYn1WoXds
	d8S5pztDLzye8GPFicuPfwd2Nzywv5+vdH1iqfymKW2bLh/6HH/td1j2z4d19y6bRnxe5lcz
	iaH31rOb0rXvDKMuJudsPFzTfnZms9Ka79PzE/wXXFOZ8tj2O8fmwobeyQVt3/XDWHwXGGyV
	LTl/tkvDRejnw0/i5ZZRktWzZpjHfG3atV5SfoWtZ235DUWmu/fb3jp2Lv5X5b7mtkJlirgS
	S3FGoqEWc1FxIgAltkrWqgIAAA==
X-CMS-MailID: 20250227053350epcas5p31b3b5b47590d70804dade59842d87b27
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053350epcas5p31b3b5b47590d70804dade59842d87b27
References: <CGME20250227053350epcas5p31b3b5b47590d70804dade59842d87b27@epcas5p3.samsung.com>

This series fixes few issues with verify, and introduces a new test
suite.

Inital few patches add the missing client/server support for
verify_write_sequence. This also changes its behavior such that if
verify_write_sequence is explicitly enabled fio will not disable it
under any circumstance.

Numerous header seed mismatch issues have been reported. This series
introduces a new option verify_header_seed which is similar to
verify_write_sequence, which allow users to disable any header seed
verification. For certain workloads which used to overwrite header seed
before verification, we simply disable the header seed checks now. This
now includes a few more scenarios such as verify_only mode, read only
workloads and workloads with norandommap, where the header seed match is
not guaranteed.

Few more fixes related to verify_offset, workloads that have offset
modifiers, verification issue when multiple files are specified, are part
of this series.

Lastly this includes robust test suite for verify.
CI run result: https://github.com/vincentkfu/fio/actions/runs/13552248490

Note: The fixes in this series doesn't cover experimental_verify and any
workload with variable block sizes.

Ankit Kumar (14):
  filesetup: remove unnecessary check
  verify: add missing client/server support for verify_write_sequence
  init: write sequence behavior change for verify_only mode
  fio: add verify_header_seed option
  verify: disable header seed checking instead of overwriting it
  verify: enable header seed check for 100% write jobs
  verify: disable header seed check for verify_only jobs
  verify: header seed check for read only workloads
  verify: fix verify issues with norandommap
  verify: disable write sequence checks with norandommap and iodepth > 1
  backend: fix verify issue during readwrite
  init: fixup verify_offset option
  verify: fix verify issue with offest modifiers
  verify: adjust fio_offset_overlap_risk to include randommap

Vincent Fu (7):
  t/fiotestcommon: do not require nvmecdev argument for Requirements
  t/fiotestlib: improve JSON decoding
  t/fiotestlib: display stderr size when it is not empty but should be
  t/verify.py: Add verify test script
  t/fiotestcommon: add a success pattern for long tests
  t/run-fio-test: add t/verify.py
  ci: add nightly test for verify

 .github/workflows/ci.yml |   2 +
 HOWTO.rst                |  52 ++-
 backend.c                |  18 +-
 cconv.c                  |   4 +
 ci/actions-full-test.sh  |  13 +
 filesetup.c              |  14 +-
 fio.1                    |  46 ++-
 fio.h                    |   9 +
 init.c                   |  43 ++-
 iolog.c                  |   9 +-
 options.c                |  11 +
 server.h                 |   2 +-
 t/fiotestcommon.py       |   7 +-
 t/fiotestlib.py          |  20 +-
 t/run-fio-tests.py       |   8 +
 t/verify.py              | 799 +++++++++++++++++++++++++++++++++++++++
 thread_options.h         |   3 +
 verify.c                 |  10 +-
 18 files changed, 1005 insertions(+), 65 deletions(-)
 create mode 100755 t/verify.py

-- 
2.25.1

