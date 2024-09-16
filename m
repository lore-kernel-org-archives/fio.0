Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C77D17BD3
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505689; cv=fail; b=lucBkRG8ar4/lC0Kzym26SVkef42TxfK9N1X/rxKFeL4y9A4GJSiK9qkbOaaCw0XH0kSUarvc/ZdPZc1SVFCDWVvsokMb7892CTWi3D3Yr7UqvN2FXAsMBRqvtT/QT8L/bBSXgtYzXWgC/07pUZZton5fqZ2KTeCCOUGwybq380=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505689; c=relaxed/simple;
	bh=C6QqE0KGUAn907rEJbZnaNewesokPKO1N+qT8lktVvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IGLxNi2S7o1S+o5v6zoiGKI7TVv7omJwGFQT/rQqjfkDEJV37rbO0pZMFKQNH53zhJ5DZ7mOPfSUNaBAStlk26ZQhwgxSIp6rGyX2TWCC4McgYKnImS3lbs/w7DVZcahYUpuxRCi2Z/MiQD/Ue3373e7QM+lWAqEYrkngWtJ4Aw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ED/9Sl8q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HJr+nijz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ED/9Sl8q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HJr+nijz"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMYEV030194;
	Mon, 16 Sep 2024 16:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=dolYFGn62EJBu+BoqC8VLpqYeWF87G4Fclejw5hrNtg=; b=
	ED/9Sl8q12lA9VFj4h4TjR4bd92WUU57tcUvDGPStMqQhf8Pvfq8XE9V/xjSoec5
	cOsC2vpZ1pQp+9a4CoCzIIOIeUM2uPVBqPHOutzraGsitIhrTONbpOaiSUKPqXCc
	QziWUB1IOquE/CDyfJIMBD4PuTHg3Q9KA5RmFsF4ytHh2wktbiKclyrOVUglq6Wf
	N+VlNfmgwQyaBBEw2kxkEOaruMjIoR6eJuZX2yXsBOthD2+V59OSyMA8NNrQNa1G
	PoOpEspKBxSuf5+eOvLnKwzxOpATtdhjtx2Nce4suXvbA+PgZD5NBQ2ZRKp93Oqd
	2z7M4Gsr4/O5c+3OLlg2vg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3n3bwnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GGKdOc011209;
	Mon, 16 Sep 2024 16:54:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb5uwd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=juznJl9Rh9CNR8CqdIH0NJJCBAWmyZaO8Li5yMph9OXPHhrvEGByq+n7SvxAVCnfEXAUY0f3dnnirgBVPnoFkbKOIMczDSG5ndxVke2zxebz7MYPIFOJrZKBp2wB3yUbAH7IDmZGIXnssh9UJiVl7E5LjxtTU8441XkPdlBvJWDCO8J+oX41bPOsV+zXeqtpO7fAAC9QdnrOmVFx9SxgDnrsJfUjjVQ6vn59lhkWmWKeR0VaRqpGysZVGOWRg/p/SdQvijtBjUTFiQgJGlCkKiNCCp7aP4XAsp8Y0jsg+8npW3/Ors6JhMAwIUCqHkMAa+0KfZz/vZ9iOGqoy7KrBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dolYFGn62EJBu+BoqC8VLpqYeWF87G4Fclejw5hrNtg=;
 b=hJJuEuDaQHpF4ehrcy6HTYkCiPLjuHQ2TKVJQ/LCZtIAdvR1B2maZpt6lcVoysBLz/UE8tmuvvJReyd0S0BQe2M9tLWQY6V7JW741MWNtmmh8h62V4aIPhoQd6NmJDh3wgyDT2sSOrvCM5uxBxTOqxMGa/70O4w99JahxCvdGOC/rjYXx9OEIIV98oJRzlr2c6QybYJOZy+vdSu2NIySGkn2KvF/3lA5wqtaagtD1WDuQcty3HG3M00jwD99pzLiyt2xIA0hNHmPv3LVzUAacllylBiGXQtJvlPJXIC2zFQvkAUIiI7CndL08au5Bx8nhZm7/7GoWUdqRuu+UFgCtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dolYFGn62EJBu+BoqC8VLpqYeWF87G4Fclejw5hrNtg=;
 b=HJr+nijzl8Li8RZEBCUQC6w3TVttxMdS03dlbJ0kBm4UuszepRmwhi/WfKk1lfg+Q2BI23kMOYGh4UHmADZ+T7cAHwqJj/50SHqV6rRZX/lt0yiXhaXZNAsNdmfpgyGv2f9EwgFZAz4LdcW8xViw/CmsPFqcJkVNkfwOf6SlJ+M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:54:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 9/9] examples: Add example for atomic write verify
Date: Mon, 16 Sep 2024 16:53:47 +0000
Message-Id: <20240916165347.2226763-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 36769780-8c93-4174-be2f-08dcd6703fb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xNFg8RgK4iClW+s/YME/P/fNXlAtw7rCHaTEWox325s6kXFGCYtncjQV56oq?=
 =?us-ascii?Q?omtbPa6KUATXF32axM/L6WP4SgoM2aSpWLoMYXaTyZ+NkyVSIy6cUb4tYb4m?=
 =?us-ascii?Q?GD7rJn1s7CYGFMBmMW0i8KtsFT8uypCN2xJgJDusFf9IGPQkxp0wDtlEkvYP?=
 =?us-ascii?Q?g3duLEFmrRn3IYKxHUtMxWY6XF5uItXBinuyzWxNjZsxia45OSkuepEUVxrj?=
 =?us-ascii?Q?cqHIXdj3vbqVfCVZMc53EJZ8XmxjC7WStyxFv8hNUZyYIWujoDu03Nc0FZWz?=
 =?us-ascii?Q?+ryoNCBF6ADkBtEKN7VPpuXKT+z3ruDSY7imOv1biIbJ+Jd7l6qwq5aJaYh3?=
 =?us-ascii?Q?eZxMKiNsQGEle6VaVjbeQVYbViM1BfhpnhrAYUD5Jy7W98daY8eU4/Gszu8n?=
 =?us-ascii?Q?D8UiVNF3dw5npD3oIZ+DEdUBP59kyXe8DDPocOYuHq/Jk2mdBDnQJkXyZMzx?=
 =?us-ascii?Q?ZAn6Y3rqkjwrrtFYxhkQKCwfTgdR+sfaK94UdwPSO6QKoi1N9faxWSspWCFL?=
 =?us-ascii?Q?5DjdC7FI611WH+Xd4Rr3pMZeLnTllTzxKhs3puEZI2e6rGuaUWpJJj1Lu9dQ?=
 =?us-ascii?Q?6yp0zrtXcriAJ76sxqF1u2cPRKT7SaL/SAJwZZHgnXV2iaaC01owru83or8T?=
 =?us-ascii?Q?3oyY4hLshqysKR91xwOUQbx740za7+bx11m3qwjK8gxyNf9GK3XwOb0pCwts?=
 =?us-ascii?Q?qV8VqOWjl8RnhTFsdj//NGOlfmyolNsZa5cgW2kssGzlBdZ+FQUozSe0rHbb?=
 =?us-ascii?Q?hrtnQ3lZZRyq2Th8rNftOf2hu0ZQTCz5jarCJScOl/ev5zUvWhucMdp0fO8m?=
 =?us-ascii?Q?/j7+FheJuTT/R8WMzjPY1jDovkrtNOp/FrGoAvUCuUmrIWW0aUgO9qp+HeEf?=
 =?us-ascii?Q?kIdQxdpM8aACCsXLhop5U/mL2VvBFtOcaHHvZhpnMIhmhsxlsGxcIgi0Jfsp?=
 =?us-ascii?Q?Q6KMVCg1v9acHtWo1Zp0aM9xphCFU27roQcdwHRnph4J4oRd/MiZ8re5I5su?=
 =?us-ascii?Q?mTEVJCXl2mlXJ6Mge35kVluHz9Ana6Zh8gCn/61sxa5PbFA1U+DXx5f9Gbii?=
 =?us-ascii?Q?dGRUiasNCKyUkD0Jg6OheEzObAQPnrU68P7AnVitGSlBun2d4q3+0fum4CRw?=
 =?us-ascii?Q?/vx+ek0bXAKscO+B1sKWzSDO807VhXgzFnyP77EhKNAUUvE0IRkKR939cndx?=
 =?us-ascii?Q?xFVxR6E+HreSCyagYGZA1PfJHY0DNfYEz4KNnvw7AKoBiG04U5wY0YblyJCL?=
 =?us-ascii?Q?iX+dndb6eACmxFoRrht1Lja2+kq3TOt0dbRMc1GduU0yZYamVxDsWPJLdYoq?=
 =?us-ascii?Q?AS15TKx3J0DDN4+oc7CED5uwxgC9sxGqITmobrCvICJs3A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Ejint9zk6K5ghLj7g3wXK8RX1F4rcC8Rn2uLKFe2/K6KBNATuWwXUieUt5d?=
 =?us-ascii?Q?iYHmQZxzSgUhoXSiJUHuF26hEATrxAIx0UwDZmyTNMHQxaUp9b6GTFQUy3Q6?=
 =?us-ascii?Q?tv4rmjo20BvBlEngbdSCnkJELAxBWvypkMUmlf8D8O2MBANXF5+YmByJG/bY?=
 =?us-ascii?Q?9thxRm4leiPAw5buj6Q1PWLD0J+0XQbecfW2gw4+lM0HvuRQWhpk7Xf7AiDj?=
 =?us-ascii?Q?Z0K2RpHY0mw16cYbZikaT3HhVg7C76DlbMDQ2PM/yXR8ks42xKBcsoRhpIV6?=
 =?us-ascii?Q?TFA4VHWdWvno9iyc+1FLHA2FdCN+LboCZ0niNXnq/1K0IXnIhZ4kP+i82ZTq?=
 =?us-ascii?Q?KfpaXws37lHHu1Y8W0fSrSjiTD+IrZhGcSn1ynxghqk+ADFJ23Wn8YpspyXy?=
 =?us-ascii?Q?ms54pvh/NuXuqdOnz6l95pHrddpw+EGMpNJUqidVAvfi7mQCZNmd2mMXFTfJ?=
 =?us-ascii?Q?AvJQUZtf7s/BIBXn5FHutwjVdeEjfRhAbdBfE/XnxfPwrps/VBXpqoBeUhCS?=
 =?us-ascii?Q?AWpMGhfC1tRM9D4b2qj/wdjN+ellBYvfpPt/9UWxAXrINzkO7mRDeAM2TmZa?=
 =?us-ascii?Q?AsmL5TYMVu11h5FlJ4jw8QTZRXN7XRuzJxSAqzkQoBnYHlNlH5A6FuJFE7UA?=
 =?us-ascii?Q?KdO02WL31ZV5S+fIkZ7fpTPFKCtKRcVBV4gHxJA6QPOPx9jvAC7XMN1YzNP4?=
 =?us-ascii?Q?m/MufYgwbHHRsww0X8A17AUeWfOh+bypR5JjUO/NLIN4O61V8V9qSs9P9/KT?=
 =?us-ascii?Q?nz9FVfnf5Ln3UoXTK6G6iUc69vHLFO1Y50rdCueDvrZ5gjUL/T/qWS6rRVPE?=
 =?us-ascii?Q?pmmIRS4RfCet+RfNUFaJSm1yeLgzUL7mLYgMffrhxUA0qBIw6lqtkGw0x1ar?=
 =?us-ascii?Q?tXnagPHbKiVrT+V8MKxJDg5srgYV7ZExKl1srOsJ20bYoPZX5LjzUH7DI0Lq?=
 =?us-ascii?Q?lSXF4pL8nB7K2QJm48yPCUFW+hAzDjcykIYD1iplCHZjATPBsw7cX1UlGF3h?=
 =?us-ascii?Q?TSayo2H/Qs0jTDJ6sfeKo1UA3QbFbwUVrJpBNz0OFx30+nNWp6hk9B6rXL1R?=
 =?us-ascii?Q?v0wXubJNy/QUsG0B8pUDUmUbqsMXEiQusa/Q5IxKOjwo92iGpS9utUjq64Yw?=
 =?us-ascii?Q?wV/cW4FhlwNKgH91KyK11f8EfUR4MES15WE3sCknoOSbTH083t6q+6dHDY/Z?=
 =?us-ascii?Q?pj6c8w6rp1SGcoF9S5hN7xkigWTjbvICuQmDsGuBpGGe+C/vZ0HSfFyufyJS?=
 =?us-ascii?Q?gbsx6Qp7rscTHEyUFAlAfH8wV+W0bol6Gv2M2uHyWTzD+XVti3PW6qJG1DnY?=
 =?us-ascii?Q?at3ddc/gysPybzYyqBF14k+TY9cJXXQZdHRDzBsMJM3OvMLU0d45Aou+fBm6?=
 =?us-ascii?Q?MJMNEXxek3KYd4d/uNM63EjsRmQThtURTKki7GhG0qj3RGygqeLe6WOQpY4X?=
 =?us-ascii?Q?K3POagE1bkGjwoC1SJVMeLpiUQpsPC0kmS3E2DoPTfV1sSbNZCTSnIfVZRX+?=
 =?us-ascii?Q?wDJhTil4sazP3pKAa16aEVlSQNspNDDMsDY/KJgxRkqXwNoTBqqYASOIRFAo?=
 =?us-ascii?Q?RjuTRZkbtOvXpJdoXSVwEmrEazwTKe7Jqx6fiNXcH9bU6yh0gb6D96wx1sx7?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sGiyh2F38XKrMZvmsHB7leRsYHU0PPGF54ITmgsuxMqojf/XXLcN1AGpkGzfrT+HypAxr7lAoawpl/ZVg55kB8s5Q2baQgRR7bPbjlyrdIdiEFpcYDZQzi1H0Dg27AaC40yDeU+Td/iZlnbUkNCAqg6g8//uHgIHd0t+idaAReyT/OZuagda+0TVkK2USBy7DNS1y9xoh2mH1IRz4+Tz2vgVUdpIEJRZgCjFN6TZpdTOyZloHE2c7YWjlADM0+//PUa1Ma9bw8Uz4PHW4Yp+1sZ+L6TniHXy/LTbXXKNnigg5ytoxK7TtAl3vrnYpOxnPTfAKNr8Y4iOUm1ncH+cOori+JFUsG1RiHtgt52SoYBGSmHPrZHaLxmvaa0AoymO0SdGqQgYu1UnFStKATs7WJaKTsV5OHPyOuEcIETsonmDOWjoFn1iFQu2Iz97zWkiCNDPO2lGj1GG+ic2AB+yAALttmnzbe/+B4fNKGhFKg3ls4OwJb6xt2fm/hkGnbsN9Bvtk4cvYP0Kj5pQ4rtpjAQbXqPtL9D+24s4WXyPZ8oE5AtAuk8rh9PsOcs+N1We3svVIoHaWv5SrYpMqd/M/u5vhHnixhMx84RCnH0Gv1I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36769780-8c93-4174-be2f-08dcd6703fb2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:37.4548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2TfG8ytY5KbsjxXZQTkOoKwdhZJS8mPHsminvN1Tud9V+p+nG80aQt2SwqQkwl2jQmH47/DsGBkkAXmANYpFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409160112
X-Proofpoint-GUID: xYP_Z9M3VQ-dtirx_MtYkCTOpSA9uz2N
X-Proofpoint-ORIG-GUID: xYP_Z9M3VQ-dtirx_MtYkCTOpSA9uz2N

Add an example for verifying atomic writes.

Until now, atomic writes are only supported on Linux for block devices, so
only give instructions on for that.

Currently support is being worked on for XFS and EXT4, and instructions can
be updated in due course.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 examples/atomic-verify.fio | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 examples/atomic-verify.fio

diff --git a/examples/atomic-verify.fio b/examples/atomic-verify.fio
new file mode 100644
index 00000000..17bcd89f
--- /dev/null
+++ b/examples/atomic-verify.fio
@@ -0,0 +1,36 @@
+# Data verification with atomic writes
+#
+# Some background on atomic writes:
+#
+# The main selling point of atomic writes is that it is guaranteed writes
+# to storage will not be torn for a power failure or kernel crash.
+
+# Another aspect of atomic writes is that they handle racing writes and
+# reads, such that a read racing with a write will see all the data from
+# the write or none. Well, SCSI and NVMe guarantee this if using
+# RWF_ATOMIC, but it is not formally stated as a feature of RWF_ATOMIC.
+#
+# Fio verify mode can be used to prove that atomic writes can make "safe"
+# racing reads and writes. This done by having many jobs in a xsum verify
+# mode. In this way, xsums should be correct, although a job may be
+# reading a data block written by another job; however
+# verify_write_sequence must be disabled, as it cannot be helped that data
+# blocks will be out of sequence between with many jobs.
+#
+# Atomic write limits:
+# For a block device, the max block size for atomic=1 is in
+# /sys/block/sdXXX/queue/atomic_write_unit_max_bytes
+# or this value can also be read with a statx syscall on the bdev file.
+
+[write-and-verify]
+rw=randwrite
+bs=4k
+direct=1
+ioengine=libaio
+iodepth=16
+verify=crc64
+atomic=1
+verify_write_sequence=0
+numjobs=10
+# Use /dev/XXX or filename
+filename=/dev/XXX
-- 
2.31.1

