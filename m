Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC28195FF0
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934694; cv=fail; b=s+CrO9wSShPjM4o16h0d5zVNLTGObMiv4UBlu7eP8MOGbpRV9Q35ElChRoUuahlKARwDYobHl6qApAMSHI6zLXcH63EydloD4xg7KNWpcpl5MK2+yAHPPRC84CqiUriYBtiSt415SffOTcHOrh2LIsSk35s6KIsn/QkYEvrz+Mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934694; c=relaxed/simple;
	bh=bSVfurN+OyMu/RL/vSOy1MqLsyRpz5TaM/Ob1LLqqME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eprSI1O9MSp/+maHwmm6sR0JH8WcLLTUIi+IVQLyOGqh4FpMsUmJV/pQWtp0ZG80+ovn/k/q0V3/uLGavE1+8E9AazeoJ5qXEBGWGtzw3kOVrEzLB9rIxL4HSaZlXq131ec3dCkwXYhQxDMlXhoX40b2zJCY5pSDOxwSMW22URU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GO5rPf9k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zskhD8jk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GO5rPf9k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zskhD8jk"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TBi1vi023801;
	Thu, 29 Aug 2024 12:31:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=SIFbP32NhfZqQ+eGuJ4Hmpr/E1t/xsquTyKvQYZNgIM=; b=
	GO5rPf9kgDVZVr2D4GG0yp3x9pTYVsKkESEjxJ415mRwdDcCTJasEK23uPph7pys
	GLSmccziVb2F2YSQQWZT63LilcCsbXFD/+yvOwzrdngjhx9mJ7s94i2UUuHWSmCn
	CPKY9qPXuqY900jQhMIed7zdma9oZCLGyG6y7qVugcj4N1kDEYeUmm1XmZXbXV/x
	eTJMr/DCbL5QYkIAMLgkGAkdV4unCB5ceTQTMQcNhujybhlfRaGpOd9fdpvWKNaf
	NzVf33sd0xWlxZrKEEoUPvMnHKBK5ucdx8TbOyEE+bNNOC4jPnUah3xa0N0cQt7W
	hm4fTgTwjmdYhJgIDU9H+g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41arbt02qp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47TCHfmw032818;
	Thu, 29 Aug 2024 12:31:28 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418a0wn1va-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 12:31:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=swzzJlBGJ8z2fQ7fHEEulf5JYYYJS2mqZ01NWOYB0gLQsygYt5juobPchq+Ky8Oi4ykl//dG+CMwfxQDGpAC1H03+dttNPEnHCWO0RBbDlACtNHDvyVEJrfAKfALb/hjveuRhVxSp6B9vIuUa51FgpqgbvsR2QCOjRXE4eiPIj+RonJA3wSgx5RhTxK9/KgVWuKIz5nIJxS2jbo0WjIsxEiKEF48/pl0FboSI/oWwx3mNEbLc9gDN73E4Amp9/MQdqTDwGXtYeCDlqEzIOQtq6KcwjGN1pSbUN5xbpPHFe1Zvegw7wSqMEAbL7u2j1a3BCqsZn9452iQcCZIYCtlsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIFbP32NhfZqQ+eGuJ4Hmpr/E1t/xsquTyKvQYZNgIM=;
 b=GiIlJF68fHmCt4q9pTu9GhW+GIs6Blp8A49ZGqVPDiCyN8i9no8ROBNtqN3a2VuBAdUn8wgQEoHmomEA/ryjxHG2cisWVekC5NYVmf3WNkMjscNZhjDwjpALzg322LUKEehd6LciJABvfoA3gGmE8/r25kpcKUH84LVic+Nehz40f2ifjxG/qHMuL/6oojr79aILlg/odY9urL+puEo5Pzd3Ym9DH1gco8ZvOXoDkAPMLqgoRjA4EMgx54mG+XqdBC8/9kew7XUEIK6PWuU1HKQ9dj+YcklQwNCvUeh9CSQWxCVaNHljFpTBFetNQbxi+gUkyZF6s2wMjDAHe5Id4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIFbP32NhfZqQ+eGuJ4Hmpr/E1t/xsquTyKvQYZNgIM=;
 b=zskhD8jk8ACBWcWUAVNxH3uKkeuI9qfpI/q4USNzi0FXc5nbfkRM9J0C4MTbCfMmOLprx1chvQkUIVVSAPysNl/x+WhjRWUWXCk72Ml64p0OzqcqkFZ4C8OdU3tq4as//kicAqO2vg1JbTveqbBgYn/YuS8p3sQCl7r0wvhyPW8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7725.namprd10.prod.outlook.com (2603:10b6:408:1e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.18; Thu, 29 Aug
 2024 12:31:26 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Thu, 29 Aug 2024
 12:31:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 5/7] pvsync2: Support RWF_ATOMIC
Date: Thu, 29 Aug 2024 12:31:05 +0000
Message-Id: <20240829123107.520005-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:a03:255::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: b3fa1dcc-c12d-4040-868f-08dcc8268020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZYaC+2p+IcaZp84QZagwD1sNpeipu1L6Y11nKUsBvdhbihR245Y6CIQSOeZn?=
 =?us-ascii?Q?svh3nIspVbvEFFFCFQ0IKj1yEMN5irjIGQ0e/3Bp5Fk40xEaLwLrqAfonHCr?=
 =?us-ascii?Q?Y0zhb0JMgRN4rNIb1V4LechcYdfPTKxnIShAG7YLJH686xVIqlXhtp4QqtaE?=
 =?us-ascii?Q?GBDasWPZKCuqQ5GI1BbGAMLVo+f2B9yDnxU/LYSn6UDPdO1YHhB81ZLosfkh?=
 =?us-ascii?Q?45E4ZimfZijNnVwzaBVvWKIoO70/mqlFxr8CR2XMC+yMqt3q0ie1Ri9r+Sj0?=
 =?us-ascii?Q?5/VoefNqNA9Bqir1qFxHv9FYdrhPy7cpsRXyRgoXz+7DgAgo7O4UktyMKFmj?=
 =?us-ascii?Q?1E3+e3B4hywIRaJqQPRTKHuOe2kJ3WUdFoXHea8u4/rgLHrDux9x2cl/kx8D?=
 =?us-ascii?Q?3J+ThJ5cwT538lWfb+n3Dt4O+e8JqbTzVKEAWT1q5aE6zcRYccgtH/VkfkPq?=
 =?us-ascii?Q?YfL0CuMOd/MvlbysoHhOi44nTblPTbc9gaoQ179yR2jsHwU0tH0WGYjCPLZO?=
 =?us-ascii?Q?ELtiGLYkM6Mh0IqZgPRfonp09G4aVI9Fs4mmAgCsEd8sybuhVAtAmPxciA2Z?=
 =?us-ascii?Q?jYCXjnruOEQ/d9RQvMH02WyyAZlO9I5+O4WKE9+/cBbNgdsQPj5D9bKKGmVy?=
 =?us-ascii?Q?JMciq/KgnDGe/JQ7Gaxz+T2ZqMeMrGcvam9VRCCACbo1edTckoVs4uOkQoDX?=
 =?us-ascii?Q?BXGlItJr/9Gc5K5m72/dsz4nJipLj+wydJ5783d5lFR5E3XZKD1xTK733mMf?=
 =?us-ascii?Q?S5oidz7oHgkT21GZmsL8dKZHFv7IW76BGXyAENamGYzyODTO8ZECSGx45UfV?=
 =?us-ascii?Q?bffoekhSbL87m1xGdtPN1xHQaCSDCkpbfsnqizooDHval71Edq7nVZzBd/15?=
 =?us-ascii?Q?BKgq13SNpntngkF/NcKbOJgks8DJp0/Dfq4r1EMez4aZqv//CkFOIzv4OZpq?=
 =?us-ascii?Q?Z+RGh0W2Ab3+H8lE6CAxQv3URSUneM1g5T5s7DOaNJlLP7wlVoXGmObyofHc?=
 =?us-ascii?Q?LinXrriNGnda/VkKL0L8KDoUtAD82pGSbRhRtEhlqwLVsEye2+e3FneTcPVY?=
 =?us-ascii?Q?b+p3BDHXonV2eRurbcsjiE89yPj7wVIxoXXStGMoen7Nod+m7ig1Xh/dVnX2?=
 =?us-ascii?Q?Hyx5Pwq6/NWUe44a5zOYhuE2SkNnr6z38RTdYTZ4xmEJltyeYdKpTSPO/IAd?=
 =?us-ascii?Q?HmNq0zLLgG4szbWA74fLdC09ir8MWbed6jiyqMGsan/8svyyvOoVVYnchnwQ?=
 =?us-ascii?Q?CyO9P/9g3UymOoxsZilFIVJo3/nAxpm/Om18t4Bnct5AZV4xH4IEudiElxOx?=
 =?us-ascii?Q?Lx4FmI6pq1ePN3nb0tF60fuT1y7mhFAuTL5E0bGUeoXGKg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?461RMZkSQRXszkhQX+if61A1/BNuQuS9lDM8fPi8nrMFhVPn+vOQsPv3/8WF?=
 =?us-ascii?Q?5uHoz3dO1pubnuMq/es3IQlnIfE7Y8D3PMdBUV1x1k+zkV71VX6JWFI0sJiq?=
 =?us-ascii?Q?Dnj95eVJVGSXv35qdeqKia4Py/D26raAPhy27GHEalHb6PN+2r4UXEJ37jI9?=
 =?us-ascii?Q?tLAgsQZjYJOg9t93niLXHndRE/4no/ZGbWYqK0GiMef5zW39eAtcDXbbU/ab?=
 =?us-ascii?Q?uu5ASp3+LNeLjcqnhubf7H0SVodVBrepYxuuRpS7VzW4YXKTPL4OVhinQxwy?=
 =?us-ascii?Q?SbZIcopU0pSrQpR/f6YkgXSe0zyIIisY4r0JHU535uhSVWVlm4tDov09Utjk?=
 =?us-ascii?Q?1OFlAEXFiFlPLYkkLs5Xk4ypBNMswldGTAO+hOOotfpeYa+iywz+r/xtMatw?=
 =?us-ascii?Q?JBpd4X9k+W45a34Hbxiebch7KPVJSgG22Fvo1a1EuvWILFF019bltdjNVh6w?=
 =?us-ascii?Q?jk9O7DEYqVBldU2qAZ1bJ4V8/UPDZ7JMJUi8BfNdlRkz549NRx4hSaPkCLER?=
 =?us-ascii?Q?DGvr2sZEHgRzxc4kns+HQ5JQoVZJmFOk901pn/kXtFHk0qVK5/y5/0F41bBH?=
 =?us-ascii?Q?zxcTj2xE2rj/NFHOqQbIPqqcJ9jPWVfsHozIFTXhzqBkjVv95+EfiQ/3etVN?=
 =?us-ascii?Q?FHns5SJjdwh5mF6+/N0eNpjFeODuPy2dpWZA4b0fCLCV+jdv5MaUgUVFBLW2?=
 =?us-ascii?Q?xYVqpZLoJiphr6HB6zS0XI+8I7MldbXwlHODXP5YnV+sYwKIOz2MGIJktCHo?=
 =?us-ascii?Q?hJ3TcgXaIE9ejFnfEpxULgdrWXH+13c1jep1OY3J17edQddSFtCbGCIjvPZ1?=
 =?us-ascii?Q?PCBCEL6r/ZU39E2aVRC/C0qCTzQkuGONUMvuLKpOg53YVXGZ+83CF3Be5Q09?=
 =?us-ascii?Q?gVcBx9neA6LPgwm3YozlYDmLt7JPRPcCnws9VawEEmAwkuNAQ0xY0MCQeqfJ?=
 =?us-ascii?Q?wkDIls5Lxwgacb8+lmmJl4aQKQLm6Tva+v1tRLSPeI0RoQnxwAcoq7lN/9C0?=
 =?us-ascii?Q?jzwZSiW8J4OEEKWwshlXZJshXE8LoHjUUrlN3OvVSMHZwInq+FP/0ulcADwk?=
 =?us-ascii?Q?8XPkL+oqp/aCIHLwgdGtFolJj9QBsxYBKCotSXJp8qAgAy85zi2Lfy+j43ub?=
 =?us-ascii?Q?J2fPHwLUckQa2Uz2NEkEZ6lxcQ+wWJILIwusj7l21cv22YrumkGwDE58lWWU?=
 =?us-ascii?Q?t6FBLrcmlnJDwL53uKsW24jSm39YNRPy77rjWKqPwjC/rDqxPwY2fLLj/uIr?=
 =?us-ascii?Q?zSnK6x4xL6ljFX7t6DpjscWxqwDkwrPMqP5SVtvsrEKxyiAvdTR/0VGzgmy3?=
 =?us-ascii?Q?4ZsMuzPN0MUADsDG/OT2rmVnhSnaM23FryoJrS41Zx2eKzlfXoA8zJIhci9I?=
 =?us-ascii?Q?pzwBgZbRNEboeWRg9Q2yx72gkElypfKYWldA0dali7kygHeXfafTGTf67Ljw?=
 =?us-ascii?Q?YVKA980gUT/r9oG24eHii8temGv35Rl008Azb71zOFQ3BLVfF2UvGI0D6hTO?=
 =?us-ascii?Q?gSkZsnLpE8Y61dVY0R7QAQYA1tcd1NZbV/kNFDbv/K29UcdLxEYHkIlJq/A4?=
 =?us-ascii?Q?c+Ps8dIsrFHZTHRXA7ttN7Kp2JJBYxuZE+LWtQui2NtxHfsZZ/b84bZlWBKV?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gF9yHnGiMboQlQoxIWixD43UcTlnR8HK0l7lAM4OkfimQXlW3vXPkh9mUDHvbttbOPAZDLPfD8O4XupNVrxcCvnJnV1e6mlPzyOg1jgjNImlCnogJgSwBa+XbJ8ibXjqAsfH6NMzmyZ5Dk7+NHrg92+4o757Jv8OTNvBJh5l4EfAHFzJOy0aUJMriLi9Czrgzrs923Tf1lkk1lqs7ELk5UwEbtBt6VoK03cnA1KoveTb1PyooQw+P8h9k1ati67lPeSxtgw7dgfO9b9iSDyNG2uQMKYokVC3ZNLlsVuwn+QTdjs+ZCrGTu49A27VuYab2dB8uF3Lj297SxM5L2UAiDQRhYpwY/B7lCkm3Dxa0dkdb/ujwfrwlwvey0tCoDmI8QjXR0SFGLnJgpq3/vn1UgR6qJVmpkNX9h0yz5s5C68RrjU5UyszxNJhdWJoNorx4e2cxhj1BG/jX53pzSkzaQfy09r9zJtS423zN4pX8m7OUvwV4lhfkxTwwegnr5XeQb8ko4ZitpOEYYaq159TI8cj1Zt0e1BupdmQPbf+AMZSWf+6mBueAkqXqOCuD3On9oS3dUIChoikK6m9M1S1Q4Ip7u4xJACOEGR2iK5JSi8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3fa1dcc-c12d-4040-868f-08dcc8268020
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:31:26.4443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPewT0smPGs6rAKuWnMaC1no54mCEiV/cU2pHNJ95Q+rfDaZyU5Pxsz9pVTGkhyLOKfl41KLUVdM2BsOTwKKqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290087
X-Proofpoint-ORIG-GUID: prJUTtAEZU-pHIQOU1LAYiG5vKj1XrEx
X-Proofpoint-GUID: prJUTtAEZU-pHIQOU1LAYiG5vKj1XrEx

Set RWF_ATOMIC for writes and oatomic==1.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 engines/sync.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/engines/sync.c b/engines/sync.c
index d1999122..6317adbd 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -182,9 +182,11 @@ static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
 
 	if (io_u->ddir == DDIR_READ)
 		ret = preadv2(f->fd, iov, 1, io_u->offset, flags);
-	else if (io_u->ddir == DDIR_WRITE)
+	else if (io_u->ddir == DDIR_WRITE) {
+		if (td->o.oatomic)
+			flags |= RWF_ATOMIC;
 		ret = pwritev2(f->fd, iov, 1, io_u->offset, flags);
-	else if (io_u->ddir == DDIR_TRIM) {
+	} else if (io_u->ddir == DDIR_TRIM) {
 		do_io_u_trim(td, io_u);
 		return FIO_Q_COMPLETED;
 	} else
@@ -483,7 +485,8 @@ static struct ioengine_ops ioengine_pvrw2 = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO |
+			  FIO_ATOMICWRITES,
 	.options	= options,
 	.option_struct_size	= sizeof(struct psyncv2_options),
 };
-- 
2.31.1

