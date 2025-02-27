Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48252165F1
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639825; cv=none; b=ppV7i0/AoaCGcdyTA3ZzW0pB998XwU41QrrqMcs3hCC9itM+j0K7Kr6jcK35VzijotbFDt6dAsDe/UJL0ffzlfYC9eAXqrgMdiQgK7A25cng8vogtgPTSOxRnkewqIil7ce9A9vpu10IB9zwBoHhTV5rJ+GIcRFEBVNSGQygJhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639825; c=relaxed/simple;
	bh=+zgi+22lFi4qUC5KqpNtHfS/xfWdpWiYhdpKeZJSeNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HkNoqudH1YNZKLiuZoswlYWGjpIg36dc4LC+Af0TdZSAJQf+CgTidMLZsDfsN09O+zmtBL/Nnt83QB572Zg+c6SYkGIcTdkAtI2PYZuezpgQVp2rfvZsmrsfK9q/K2FFqsqtjAfetuUPG2tZVUEV3ztnsvfHV4vZrDYUKRsbYEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Q9ZCds5s; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Q9ZCds5s"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070340epoutp01e5288e5dbd510779b24db71bb30af529~n-rHBuxx92750627506epoutp01B
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070340epoutp01e5288e5dbd510779b24db71bb30af529~n-rHBuxx92750627506epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639820;
	bh=FxZJ5Cd+2xbW3qQOfMAm4SR/lqjX5PYn0GbKBBx4zds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9ZCds5sTdH+T/2PZp1yX08hSH5lP/geOJ4rFd3ELERARKTTyVhp7PRhwcLj8YuaA
	 tspPt4tNEyXErGASd2BTMxFhYr989HxEsytICCwfUeKPG5dKON52N7yJOw/1tcXTJ2
	 2Z3u3FiGqwVw0tLzKbU5aqgwP7VcFddMJzDe9yRs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250227070340epcas5p2f4eee1370d19afb73267edd27eb8c28e~n-rGpnH931466914669epcas5p2d;
	Thu, 27 Feb 2025 07:03:40 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z3Mkd6lrpz4x9QC; Thu, 27 Feb
	2025 07:03:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BE.B1.20052.84E00C76; Thu, 27 Feb 2025 16:03:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250227053351epcas5p16500419aa17a3d86f1802332000c8e1a~n_csq4ixQ1213912139epcas5p1j;
	Thu, 27 Feb 2025 05:33:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053351epsmtrp2bffe0bd2f4d07bb87ab76711986b4539~n_csqAheK2879728797epsmtrp2i;
	Thu, 27 Feb 2025 05:33:51 +0000 (GMT)
X-AuditID: b6c32a49-bb50c24000004e54-97-67c00e4892f9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	82.A3.18729.F39FFB76; Thu, 27 Feb 2025 14:33:51 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053351epsmtip205dfacc25df0d5f7df18040a6dc808bd~n_cr_Lkch1586815868epsmtip2f;
	Thu, 27 Feb 2025 05:33:51 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 02/21] verify: add missing client/server support for
 verify_write_sequence
Date: Thu, 27 Feb 2025 16:17:08 +0530
Message-Id: <20250227104727.1794982-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmpq4H34F0g4trJC3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOaHi+l61goUDFsxN9bA2Mz3i7GDk5
	JARMJL7f/M3UxcjFISSwm1Hi95QFUM4nRonZ9zcxQzjfGCVedO5nh2m5tvYaO0RiL6PE096J
	rBDOD0aJeyteM4JUsQloS7x6ewOonYNDREBDYs3dVJAws4CdxNXDL9lAbGGBGIl3e++zgtgs
	AqoSrS0dzCA2L1DNknldzBDL5CVmXvoOtphTwF7iTWcjC0SNoMTJmU9YIGbKSzRvnQ12qYTA
	MXaJtfsPsUI0u0j86pgANUhY4tXxLVAfSEl8freXDcLOltj08CcThF0gceRFL1S9vUTrqX6w
	+5kFNCXW79KHCMtKTD21jgliL59E7+8nUK28EjvmwdiqEn/v3WaBsKUlbr67CmV7SKy5DhIH
	hdUkRomWHctZJzAqzELyzywk/8xCWL2AkXkVo2RqQXFuemqxaYFhXmo5PJaT83M3MYIToZbn
	Dsa7Dz7oHWJk4mA8xCjBwawkwsuZuSddiDclsbIqtSg/vqg0J7X4EKMpMMAnMkuJJucDU3Fe
	SbyhiaWBiZmZmYmlsZmhkjhv886WdCGB9MSS1OzU1ILUIpg+Jg5OqQam3gfPyrcHZrzvP7fE
	QCDU1eX0tOvOda4XLn/t3SwXt/FV2p3EPTYHzv6V9tj+67PelPXMW6rdzOcddNGy29MuLq3+
	Vyms53D/wkVsBa/rF0VMVSr9rfWv1p7/qNgHtxZf/VQGZWEP14VX3zZdXRkdrZp15O6NqmOP
	VNbKysru22eaHpu8YOlBJom/PoamnqHmZoalXcbtkYx7zs8QlVq18p226gUN1eO/BOby5Xq2
	6i+/kcatvdXl7oHUfcIlL5Ze32jtI7XhXdnVE//VHEx1eXqcAh7lSOjvF4r6bcP4I59594XS
	X79kFnz7MmXWzX//rrEcWuw/XeP3hgmBZVVzM1Z8Pnzm25EfN1+9rfR/o8RSnJFoqMVcVJwI
	AILg5BANBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvK79z/3pBu9fW1qsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXR8HwvW8FC
	gYpnJ/rYGhif8XYxcnJICJhIXFt7jb2LkYtDSGA3o8TlX71ADgdQQlpi4fpEiBphiZX/nrOD
	2EIC3xglJs3RALHZBLQlXr29wQxiiwhoSRxb18QGYjMLOEj827UFzBYWiJL4su0rC4jNIqAq
	0drSAVbPK2AnsWReFzPEfHmJmZe+g83nFLCXeNPZyAKxy05iwcRvTBD1ghInZz5hgZgvL9G8
	dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECA5TLc0djNtX
	fdA7xMjEwXiIUYKDWUmElzNzT7oQb0piZVVqUX58UWlOavEhRmkOFiVxXvEXvSlCAumJJanZ
	qakFqUUwWSYOTqkGJhljiamXM1dNPcLysbXsVH++wuPXDcVzzi7n+uHUYvGz24ctubLkmW2y
	3vdjW9fzG57lvG7lLd/0rL17sqlK05JtRSoMtmd3huf6Sd38/PTHrQrG6tKZdW0O3dZfg3eo
	M2Rq2kdzl/HeYpz6wKWez/SF2cLDLGf0zQ94Xq+rmrb78YEVT5zfvRfJ39g++1rAFf6VwYIP
	mQTv2xX2LlreeiSv596UHOn7p/LXiOb3ZimI7agIVLKqmtV96q6QpsKK3ffDWTKuNcl5Tpf4
	wu1/N2eiZPgOYdEARyv53YJ80WuOXDu0fv+ztO0NO/9UvolYbfnVPVGsJChgT8aO08tmMCzj
	brvI9Ohp0erU0/vnKbEUZyQaajEXFScCAM532V/CAgAA
X-CMS-MailID: 20250227053351epcas5p16500419aa17a3d86f1802332000c8e1a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053351epcas5p16500419aa17a3d86f1802332000c8e1a
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053351epcas5p16500419aa17a3d86f1802332000c8e1a@epcas5p1.samsung.com>

Ensure that we convert verify_write_sequence option for client/server.

Fixes: 2dd80ee4 ("fio: Support verify_write_sequence")

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 cconv.c          | 2 ++
 server.h         | 2 +-
 thread_options.h | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/cconv.c b/cconv.c
index 9571f1a8..ef3fbaa8 100644
--- a/cconv.c
+++ b/cconv.c
@@ -182,6 +182,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->verify_state = le32_to_cpu(top->verify_state);
 	o->verify_interval = le32_to_cpu(top->verify_interval);
 	o->verify_offset = le32_to_cpu(top->verify_offset);
+	o->verify_write_sequence = le32_to_cpu(top->verify_write_sequence);
 
 	o->verify_pattern_bytes = le32_to_cpu(top->verify_pattern_bytes);
 	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
@@ -442,6 +443,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->verify_state = cpu_to_le32(o->verify_state);
 	top->verify_interval = cpu_to_le32(o->verify_interval);
 	top->verify_offset = cpu_to_le32(o->verify_offset);
+	top->verify_write_sequence = cpu_to_le32(o->verify_write_sequence);
 	top->verify_pattern_bytes = cpu_to_le32(o->verify_pattern_bytes);
 	top->verify_fatal = cpu_to_le32(o->verify_fatal);
 	top->verify_dump = cpu_to_le32(o->verify_dump);
diff --git a/server.h b/server.h
index 449c18cf..d31cd688 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 107,
+	FIO_SERVER_VER			= 108,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index d0e0a4ae..4d8addc4 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -484,6 +484,8 @@ struct thread_options_pack {
 	uint32_t experimental_verify;
 	uint32_t verify_state;
 	uint32_t verify_state_save;
+	uint32_t verify_write_sequence;
+	uint32_t pad2;
 	uint32_t use_thread;
 	uint32_t unlink;
 	uint32_t unlink_each_loop;
-- 
2.25.1

