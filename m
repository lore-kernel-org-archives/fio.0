Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DD6C132
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 06:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706165224; cv=none; b=b9+JUsZSJCbrTR7VwVuUL+R7NezU9HvvfVln9FbB6FXlkIoG067pkL+CaMvOZkowE+7FK9ICIekLPvVOwsRuH+twaYQOdcEFVTiddDpSEfkCNA6AqM4gmM/4qCujk7N6BBOhvJgTMmpPK7RBGEevHAclzoAkt4Iak90oimO1meY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706165224; c=relaxed/simple;
	bh=CnoS8e5Md8uoYGxSdO5qp7GHtg8+EyuBP42puBeHHCA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=mV8LQUOjrf7maDv5T/SFQTkfor0I1PwBW+u3G76UVwTQtlb+o54r/eED6WwOGmGeHz6JNum9zBSaha2FQTzv7IwiXviTMr9qFM9bY6bP0P4ED5ftAgTj8NXO2lOwwcXx/vuH5/9UCCo6oZbcamzS00w1F2s8uvwncuJ3sJ3prm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PhZ7AaYu; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PhZ7AaYu"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240125064659epoutp03955bcb789592c4c5404de9ee18a2464a~thDohi_zP2697626976epoutp03p
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 06:46:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240125064659epoutp03955bcb789592c4c5404de9ee18a2464a~thDohi_zP2697626976epoutp03p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706165219;
	bh=urd1rvvzZeBM9hugVV7Ot3DQe10w1NJxR/us8pGNkzI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=PhZ7AaYukiYqVrwwMGZL8NC9+i34SbwhxGDEcfrwcXHtaGaT9vqJIDMko7nRg8WOP
	 mjiHt59XCKFSpaPNqYq2SWrWoy03Qv4NhkpzxhJp8f+q3nMfjrgMZOZMN3m0u381J/
	 NQMgssmz2BdjvMCGnC38A/J1ogx/oek0yxo21FvI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240125064658epcas5p1f483fd8423b514111d9fc443ca55da82~thDoTj6K12858628586epcas5p1e;
	Thu, 25 Jan 2024 06:46:58 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TLBFY0lPdz4x9Q0; Thu, 25 Jan
	2024 06:46:57 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	32.93.09634.BD302B56; Thu, 25 Jan 2024 15:46:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240125054350epcas5p3b4116e69a99e57421c5c22989e5cfb7a~tgMf8Pxg60599005990epcas5p3m;
	Thu, 25 Jan 2024 05:43:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240125054350epsmtrp1345438f612b18416b44e2ade0c761466~tgMf7n9D62122321223epsmtrp1S;
	Thu, 25 Jan 2024 05:43:50 +0000 (GMT)
X-AuditID: b6c32a49-eebff700000025a2-e2-65b203dbca9c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	28.99.08755.615F1B56; Thu, 25 Jan 2024 14:43:50 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240125054349epsmtip103a6407d34db76c70e21e98e5dcc1dae~tgMfO4gMW2925229252epsmtip1D;
	Thu, 25 Jan 2024 05:43:49 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 0/2] log both average and max values over the window
Date: Thu, 25 Jan 2024 16:31:22 +0530
Message-Id: <20240125110124.55137-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsWy7bCmuu5t5k2pBtd/qVmsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdcb1nGmvBFK6KT5eDGxj7OLoYOTkk
	BEwkbj/sYgGxhQR2M0pMvm3ZxcgFZH9ilPjadYsdwvnGKLG6cRIbTMer7xfYIBJ7GSU+nlrB
	DOF0Mkl07nnAClLFJqAt8ertDaAEB4eIgIbEmrupIGFmATuJq4dfgg0SFnCX+H0HYjWLgKrE
	1BMrwFp5BWwkzlxrYYVYJi8x89J3doi4oMTJmU9YIObISzRvnQ22V0JgE7vE84NLWCAaXCSe
	377PBGELS7w6voUdwpaSeNnfBmVnS2x6+BOqpkDiyIteZgjbXqL1VD/YzcwCmhLrd+lDhGUl
	pp5axwSxl0+i9/cTqFZeiR3zYGxVib/3bkOdIC1x891VKNtDouv9R0ZI8MZK7LjewjiBUX4W
	kndmIXlnFsLmBYzMqxglUwuKc9NTi00LDPNSy+HRmpyfu4kRnOq0PHcw3n3wQe8QIxMH4yFG
	CQ5mJRFeE9ONqUK8KYmVValF+fFFpTmpxYcYTYFhPJFZSjQ5H5hs80riDU0sDUzMzMxMLI3N
	DJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYJqhxepiEb/5eshMwaopQoGJey2Wn9CMC3e3
	6dQzDbWKCDPq/fjq6IbKSdkMF/VfuU3tOdaffC9C8SfvJC5Dt9tP/+tNe6mkYeWxV/ZAQnjp
	K5v9W7hP5/35smi/1nMu1pRU9qJVAmWJf0+4/EtJVm3b+MP32GHG945KS099OPmLM9SjZ8qx
	mk6h6yc2nFkXuvS77s5w8y+fbZ+cnyh++NIWeY0vL4rlJur6/PltaS7TFyXHLO26g/PXn0Sd
	/1LFxho9Z0pZG/7+TLZvDlq2rj/F7U+Zk7XJHL6g4yHFIcyRZTf41G58tL+4teX2o9+MRjuP
	+t7X4PxZJy+5ODlQkfmdzv43BXobXvruerj5lhJLcUaioRZzUXEiANvoGfH+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsWy7bCSnK7Y142pBp3TeCzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mq43jONtWAK
	V8Wny8ENjH0cXYycHBICJhKvvl9g62Lk4hAS2M0oMfdcD0sXIwdQQlpi4fpEiBphiZX/nrOD
	2EIC7UwSx1+JgthsAtoSr97eYAaxRQS0JI6ta2IDsZkFHCT+7doCZgsLuEv8vtPFAmKzCKhK
	TD2xghXE5hWwkThzrYUVYr68xMxL39kh4oISJ2c+YYGYIy/RvHU28wRGvllIUrOQpBYwMq1i
	lEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgOOi3NHYzbV33QO8TIxMF4iFGCg1lJhNfE
	dGOqEG9KYmVValF+fFFpTmrxIUZpDhYlcV7xF70pQgLpiSWp2ampBalFMFkmDk6pBqaImfv+
	V/Zmp80QYd6cqXWM7/PjYImgxw+nqy/rzWKV1n0dI7WsePGrrx4/6lyT5M2sCouuGvrL7BMW
	ftVczLO19NF38YbN1X3JX2qXyJt8PvGE7/c8pfCYBouZN+89WMJVLrwp6drMIp9okxcOd1ZU
	+oactUgp0tN/5b83oSdv8lHvc727HK5de5ngkXv3ebqe3P+ElEsztKuzs48cu1V2c8fme3cO
	TdRonRzNnbn9yaEFn2t3n08y4S35Uvcv6pXbgoSz+rbT33aGzrj06mT+zbDHe+p7hd/9MtzX
	dXz+hE8P5vh83bNW8+3q6LDZS0Uk92Sk7H5ccv/8EuOeI+eLZzfNOhXGFK4+aXPPD4YlSizF
	GYmGWsxFxYkAXoMWiKkCAAA=
X-CMS-MailID: 20240125054350epcas5p3b4116e69a99e57421c5c22989e5cfb7a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240125054350epcas5p3b4116e69a99e57421c5c22989e5cfb7a
References: <CGME20240125054350epcas5p3b4116e69a99e57421c5c22989e5cfb7a@epcas5p3.samsung.com>

This series adds an alias log_window_value to option log_max_value which
now report average, max or both the values. The log_window_value option
type has been changed from boolean to string but retains backward
compatibility by allowing =0 and =1 values to specify avg and max values
respectively.
There is no change to existing log formats while reporting only average
or max values.

The fio documentation has been updated specifying the new log format
when both values are reported.

Changes since v2:
 - Fix man page as suggested by Vincent.

Changes since v1:
 - Use posval for strings instead of magic numbers as suggested by
   Jens.
 - Change option name to log_window_value and add alias to log_max_value
   as suggested by Vincent.

Ankit Kumar (2):
  stat: log out both average and max over the window
  docs: update fio man page for log_window_value

 HOWTO.rst | 45 +++++++++++++++++++++++++--------
 client.c  |  6 +++--
 fio.1     | 47 +++++++++++++++++++++++++++--------
 iolog.c   | 74 ++++++++++++++++++++++++++++++++++++++++---------------
 iolog.h   | 21 +++++++++++++---
 options.c | 34 +++++++++++++++++++++----
 server.c  |  6 +++--
 stat.c    | 32 ++++++++++++++----------
 8 files changed, 200 insertions(+), 65 deletions(-)

-- 
2.25.1

