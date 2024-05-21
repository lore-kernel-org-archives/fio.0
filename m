Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5BA81E
	for <fio@vger.kernel.org>; Tue, 21 May 2024 00:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716250311; cv=none; b=Tpw6aKqcLGcRdqZXBO0tQTmqdNKsDjkptz0GO+v0BKBqQ48cNlemeLEZkTzCQoNjPnDtAzxXOIFdwCBxT/UYnhCpHjj3nU5CAnUg0Ac2vr5/WW1WXbGPT2mAmTRFILj9CShsGnEkJQNCIENWaZjO8dDvgBNkut4+qdCz/5ykawo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716250311; c=relaxed/simple;
	bh=nPiMuxBUZqvdLeMigN41KuiSDz9ef77PmBZlQul5lU8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=ddJUiGEwRzvyQsy9SCkgx8seyPvX9uepfhfrUP+LzwwWVI8KqobfJscJHIVS9WGG8Y43a8X3P0qdE6Ym29Qs7lZxqLBDC48WeYuhc2D2VIkzu13EX1Z5cNHzMgSKNHWhDZnLZShDMYgvfbZowrJL2jftcQA84sWxL1SmL/PP2TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UX40/SL8; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UX40/SL8"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240521001139epoutp029ede41c18fba92ef89f9ccb3a924ce6d~RWI4B3UK02307123071epoutp02F
	for <fio@vger.kernel.org>; Tue, 21 May 2024 00:11:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240521001139epoutp029ede41c18fba92ef89f9ccb3a924ce6d~RWI4B3UK02307123071epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716250299;
	bh=odk9UFTgvJJnVhoERpK8WEXG05HcRNdTF+oEHQYmagw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UX40/SL8SFcyOqIAjR+l+yLvUJ0o+q6FxSaaLDVAbkbvZM/0Zej2RIfu38bc0Em7h
	 WKwACFJxoRPlz07UosMXKvSF3XnE2Y0HLFYw5EJtC39uOeCin08XvViE6D/7ewDidD
	 9TYeRSqLAN7MI36/ylPudRQnpl/Z7dloLKTUttyU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240521001139epcas2p44ec0bb5d39575712405632cdded99bff~RWI3p_t0r1556115561epcas2p4J;
	Tue, 21 May 2024 00:11:39 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.100]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VjvxR1drXz4x9Pp; Tue, 21 May
	2024 00:11:39 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	65.8F.09665.BB6EB466; Tue, 21 May 2024 09:11:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20240521001138epcas2p21b6ce7df4d4a5e72efd91d0774ef3d50~RWI2_tJQa1162411624epcas2p27;
	Tue, 21 May 2024 00:11:38 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240521001138epsmtrp197387f1cde0b707e1f7be95ad4d12fc5~RWI2_Mqsd0324503245epsmtrp1O;
	Tue, 21 May 2024 00:11:38 +0000 (GMT)
X-AuditID: b6c32a47-b9bfa700000025c1-6f-664be6bbe0ac
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C8.8C.09238.AB6EB466; Tue, 21 May 2024 09:11:38 +0900 (KST)
Received: from localhost (unknown [10.229.54.230]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240521001138epsmtip1095257fe8ed9c2e882d70be09f8added~RWI2z4y7m2279822798epsmtip17;
	Tue, 21 May 2024 00:11:38 +0000 (GMT)
Date: Tue, 21 May 2024 09:00:44 +0900
From: Minwoo Im <minwoo.im@samsung.com>
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org, Minwoo Im <minwoo.im@samsung.com>
Subject: Re: 
Message-ID: <ZkvkLAsm4e1mrYxa@localhost>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4e703542-b839-4e69-af59-847e26dc1722@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7bCmue7uZ95pBtsmcFp8nPWC2eLZ6QPM
	FhvaBB2YPXbOusvu0bdlFaPH501yAcxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqG
	lhbmSgp5ibmptkouPgG6bpk5QHuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQXm
	BXrFibnFpXnpenmpJVaGBgZGpkCFCdkZSxfNYSxoZK2YfNe0gXEOSxcjJ4eEgInE3punWbsY
	uTiEBHYwSiw984YdwvnEKHHp6CQWCOcbo8SvrrNMMC0b392HatnLKNH6uA3Kec4osfv7V3aQ
	KhYBVYnz/bOYQWw2AXWJhqmvwBaKCKhIHDwwFcxmFrCSOD5vF9hUYQFeiZVvJwLVc3DwCmhI
	HH4VBhLmFRCUODnzCVg5p4CtxPSrv9lAdkkI7GOX2LrpGQtIvYSAi8S6aTIQxwlLvDq+hR3C
	lpJ42d8GZZdL/HwziRHCrpA4OOs2G0SrvcS15ykQ12RIfO44zQwRVpY4cgvqSD6JjsN/2SHC
	vBIdbUIQQ5QlPh46xAxhS0osv/SaDcL2kDi0fSM0QNYzSrx4sIl1AqPcLCTPzEKybRbQWGYB
	TYn1u/QhTGmJ5f84kEQXMLKuYhRLLSjOTU8tNiowhkducn7uJkZwktNy38E44+0HvUOMTByM
	hxglOJiVRHg3bfFME+JNSaysSi3Kjy8qzUktPsRoCoyXicxSosn5wDSbVxJvaGJpYGJmZmhu
	ZGpgriTOe691boqQQHpiSWp2ampBahFMHxMHp1QDk/qiQ46XUpmDBO5ukf7m9anxdj2/vJ9q
	f1TxmSlB2w+vOt5Ws6vZ9RxfFuOlC0V1QhWBz6K+Cn2IlD2m1qNwV6p139vva578a03sXLi9
	Timx5HqGYtXcNpfXpTO/SH98sq2J52uOelKXgvQTrYx0kdMFSavaj01Mb3xhEiFUL1ahPv0b
	82I97xcJqgH//wrFPT3D0//auLRlesZz2amVgs1yfyPF2jdfPvp48g2uzH2xx0szuiNPa1w/
	r2d/PySp8pXg+9c5odffP1/E/eVexDWfktdnp/62lv9/Zel2zp0Te1d957Ntnfu2SCR7AQNP
	y7ofSqe8+zpszwmrBn/8nLNlI6f85cA3Pj8km6dOUmIpzkg01GIuKk4EAFJdwAH7AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsWy7bCSnO6uZ95pBiu26Vl8nPWC2eLZ6QPM
	FhvaBB2YPXbOusvu0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBl/nz9mLzjCVPHiay9LA+MP
	xi5GTg4JAROJje/us3YxcnEICexmlNg96z4TREJSYt/pm6wQtrDE/ZYjUEVPGSVedywHS7AI
	qEqc75/FDGKzCahLNEx9xQJiiwioSBw8MBXMZhawkjg+bxfYUGEBXomVbycC1XNw8ApoSBx+
	FQYxcz2jRMe782BzeAUEJU7OfALVqy7xZ94lsHpmAWmJ5f84QMKcArYS06/+ZpvAKDALSccs
	JB2zEDoWMDKvYpRMLSjOTc9NNiwwzEst1ytOzC0uzUvXS87P3cQIDlYtjR2M9+b/0zvEyMTB
	eIhRgoNZSYR30xbPNCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8hjNmpwgJpCeWpGanphakFsFk
	mTg4pRqYavplfs06qf5i4rmCi5KqW2MFpy2deHPdS+7fkr8+pUuUGHrvjOyd2H1d9MG9ydFz
	Xe/7Wt6MzQorUjvWbSnnu02bX1Fwy9XkCWznrSPEnk7W6nt6hUXrOJ9sXbPbS7XlVzzX7Nr9
	efEFLUdB5/RTa1fbn9n/IPdP7Aa7P8ed9FubVCrrOyd85ClcecJ+/t/ZNy5ppbWbfDcy4P2/
	IfhP+uLSgHgOvztSRlN7stfMkCk/1RzzX3PCIXPtNS94PWMUw5ZMtZ5mdTnnZufDgqgnczz0
	bK+8Wv2c/xRz848lN+s7zp9UmFrleUnk6KJbb3il73d07D/87vcvz4sS61mm9mxwPrLCIv/b
	6ZLEUul1rkosxRmJhlrMRcWJAEg9DRzFAgAA
X-CMS-MailID: 20240521001138epcas2p21b6ce7df4d4a5e72efd91d0774ef3d50
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----ChpodB-R1Sm0Ic_OC6emn_ijSHvZOLCo._OcAO3DDrFkDE5c=_29377_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240520102002epcas2p3d0944968114a664556cbd74d53beddee
References: <CGME20240520102002epcas2p3d0944968114a664556cbd74d53beddee@epcas2p3.samsung.com>
	<ZkshRcr4c0GN8xLi@localhost>
	<4e703542-b839-4e69-af59-847e26dc1722@gmail.com>

------ChpodB-R1Sm0Ic_OC6emn_ijSHvZOLCo._OcAO3DDrFkDE5c=_29377_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline

On 24-05-20 09:34:15, Vincent Fu wrote:
> On 5/20/24 06:09, Minwoo Im wrote:
> > subscribe fio
> > 
> > 
> 
> Minwoo, here are instructions for subscribing to this list:

Ah, my bad.  I should have sent to majordomo@vger.kernel.org.

Thanks!

> 
> http://vger.kernel.org/vger-lists.html#fio
> 
> Vincent
> 

------ChpodB-R1Sm0Ic_OC6emn_ijSHvZOLCo._OcAO3DDrFkDE5c=_29377_
Content-Type: text/plain; charset="utf-8"


------ChpodB-R1Sm0Ic_OC6emn_ijSHvZOLCo._OcAO3DDrFkDE5c=_29377_--
