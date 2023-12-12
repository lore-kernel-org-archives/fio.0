Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Md6tabL7"
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3F89B
	for <fio@vger.kernel.org>; Tue, 12 Dec 2023 01:52:12 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231212095210epoutp01092ec2c5ecdc742694270d844ef4a448~gDMwzpKB40544805448epoutp01i
	for <fio@vger.kernel.org>; Tue, 12 Dec 2023 09:52:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231212095210epoutp01092ec2c5ecdc742694270d844ef4a448~gDMwzpKB40544805448epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702374730;
	bh=KVSquv45guMJXrvZ5/Gr0LcawIB5YvQKf9k4oDXWnKI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Md6tabL74lU+baHhjAQ3/1UPwyktcjXwON/nlwLLT5Hx5INXkOgVRgZe/7i58+WTw
	 mGcMVprvyQeIGtBsoCs0RyUF7wBMT8Z2MpZ9+oFhjRlFC52WpdsJw6lb/ty3m4TP3w
	 YFC7mGBUjOsYjDXnuP0Ydj1dBPyqp8yvr7uoDys8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20231212095210epcas5p23dcc0ab74f14f423a8d5fd4587425b3d~gDMwhVFBo0043500435epcas5p2h;
	Tue, 12 Dec 2023 09:52:10 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4SqDRX377Qz4x9Q5; Tue, 12 Dec
	2023 09:52:08 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	18.54.19369.84D28756; Tue, 12 Dec 2023 18:52:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231212092942epcas5p28e0b580bf48a7d932f1d801a7d4226dd~gC5J6n2Ej3261632616epcas5p2J;
	Tue, 12 Dec 2023 09:29:42 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231212092942epsmtrp14e0bf1033582852ff9e41454012d0161~gC5J6ANGj3054030540epsmtrp1j;
	Tue, 12 Dec 2023 09:29:42 +0000 (GMT)
X-AuditID: b6c32a50-9e1ff70000004ba9-6e-65782d486356
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	66.50.18939.60828756; Tue, 12 Dec 2023 18:29:42 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231212092942epsmtip14d6f565077f880fa6b96f5fa30875b36~gC5JM10tx2887728877epsmtip13;
	Tue, 12 Dec 2023 09:29:42 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH] engines/io_uring_cmd: skip pi verify checks for error cases
Date: Tue, 12 Dec 2023 20:17:18 +0530
Message-Id: <20231212144718.568406-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmpq6HbkWqwdUn4hZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnrD92gqlgMVvF5fkL2RoYW1i7GDk5
	JARMJL5//8HYxcjFISSwh1Hi+rz5UM4nRomzM2exwDn7Vy5mgWl5umoVE4gtJLCTUeLqi2SI
	ok4miVn3WsESbALaEq/e3mDuYuTgEBHQkFhzNxUkzCxgJ3H18Es2EFtYwEeid90aMJtFQFXi
	0Z4DjCA2r4CtxM5Hv9ghdslLzLz0nR0iLihxcuYTFog58hLNW2czg+yVEFjFLvF103lmiAYX
	iZ0P+xghbGGJV8e3QA2SknjZ3wZlZ0tseviTCcIukDjyoheq116i9VQ/2M3MApoS63fpQ4Rl
	JaaeWscEsZdPovf3E6hWXokd82BsVYm/925Dw0da4ua7q1C2h8SZ1tfskLCKlVj07wfjBEb5
	WUjemYXknVkImxcwMq9ilEotKM5NT002LTDUzUsth0dscn7uJkZwutMK2MG4esNfvUOMTByM
	hxglOJiVRHhP7ihPFeJNSaysSi3Kjy8qzUktPsRoCgzkicxSosn5wISbVxJvaGJpYGJmZmZi
	aWxmqCTO+7p1boqQQHpiSWp2ampBahFMHxMHp1QDU4Mw6zO9iOvaOs/e6VhfYLh9/M0O9a9r
	0mWnRx45ndJe9ezY5jy2nQ2J0/zUPS75M035bh3J5Rn3Kn3GJO6op3Zx2YoWhVdX3Hd/6X3m
	64GQrvl1z34+bLRQmr3kyazFl/qrbN7GHapabqNtGv7d7GHytFv254x6Oydu3mjHJ+2v8oL3
	Y41C2/Z+ZYuwS8ZLth9V3Nbnsa3lUcSrJWknf1XF7yytiAqtLv474433rEfv/DNeLlm88/nO
	b7MT3n6b5Ol40TBBZYds9rd9MaxOqfa3dj+PVZDu49JIiFI4svP7y6DFE7nO7mXX3pl9Wfyd
	VcX0m2uvVb3UXT79c+WuM9rJUipSUa+PcPolabYa+SmxFGckGmoxFxUnAgBXS/jxAAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsWy7bCSnC6bRkWqwc0nxhZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGWsP3aCqWAx
	W8Xl+QvZGhhbWLsYOTkkBEwknq5axdTFyMUhJLCdUaKv6xSQwwGUkJZYuD4RokZYYuW/5+wg
	tpBAO5NE86c0EJtNQFvi1dsbzCC2iICWxLF1TWwgNrOAg8S/XVvAbGEBH4nedWvAbBYBVYlH
	ew4wgti8ArYSOx/9YoeYLy8x89J3doi4oMTJmU9YIObISzRvnc08gZFvFpLULCSpBYxMqxhF
	UwuKc9NzkwsM9YoTc4tL89L1kvNzNzGCw00raAfjsvV/9Q4xMnEwHmKU4GBWEuE9uaM8VYg3
	JbGyKrUoP76oNCe1+BCjNAeLkjivck5nipBAemJJanZqakFqEUyWiYNTqoHJQvuGr29dClNq
	wq6HQXNLL5snyPeKMd05PUVjP69DmqDpWhmdLvn4A+/ne3w/voTvuVmGLqPe9gSD37Hhtwsr
	jy9os3D64rl2V0z0PP/fYR/ZvTu2lHVO89TKKPilofpZ/eTPGSz/A/o7nRWusewNu9E4+5Cw
	nmTbm9ZVHVGaN/g3WHk6/Hx6c8dl1+wPZnXdGbNNS/4cdNz/YUNp48u1T5bnc03/pfgmu0VC
	4KVd2snFcvPaNv54brZF8qGl4BG7P9vjF1ws+m1wU7/C4nDEqdi0e3GLex/zClndbHk3Z1Jf
	oKfzj7WbXpX+erdQ3Oz8+RKFzOVCCvfCnrKEtVSrucqrcd5Mki1Q2Dzz5H4lluKMREMt5qLi
	RAAZMmfopgIAAA==
X-CMS-MailID: 20231212092942epcas5p28e0b580bf48a7d932f1d801a7d4226dd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231212092942epcas5p28e0b580bf48a7d932f1d801a7d4226dd
References: <CGME20231212092942epcas5p28e0b580bf48a7d932f1d801a7d4226dd@epcas5p2.samsung.com>

If any error is observed for read requests, skip all end to end data
protection checks.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5ae3135b..c0cb5a78 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -468,10 +468,12 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	cqe = &ld->cq_ring.cqes[index];
 	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
-	if (cqe->res != 0)
+	if (cqe->res != 0) {
 		io_u->error = -cqe->res;
-	else
+		return io_u;
+	} else {
 		io_u->error = 0;
+	}
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		data = FILE_ENG_DATA(io_u->file);
-- 
2.25.1

