Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA7117BD3
	for <fio@vger.kernel.org>; Mon, 16 Sep 2024 16:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726505668; cv=fail; b=DlTg4HQMX61xHoGg6yUcOUqN0e7YgPcfjyj1ZGFiwoaIKPK1u/QhBs9o1nVuZIXSy3DAGNvSj2SC/MHl4IJ2XIprxA2ZW97flCR5l9DJbnCCdmkDW9oVGiKNyIIl++Tih6WYMRd1LlDCM8mcqR6oxTB0Y1Tg2olFkjwAK4NrNMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726505668; c=relaxed/simple;
	bh=NGZO8wx/O5COdgbmASSuhZj0QsRgcn7I+iEpqS2iIsU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IWLNuQ0e9zBZm+YyTI371ox00fIUJlqKAfbIys0B0eat+P3RDZFY4XHZcs8xhoYZNP/HYX0IVmIyTNdSW2Z5eWEgkphGejJU10NRMpg0kq5fI6fhMHPC6mp9HZg6RyvDV6mvBmP099XvfkEKabDHFAlQrwOzbBEenCvLl5MHPnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NEtLmtj1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f7c+7m+R; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NEtLmtj1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f7c+7m+R"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMbl9022284;
	Mon, 16 Sep 2024 16:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=7wApiMeHTFOXq0txSy++5unXkrSDcIhLpYTvNPfedGE=; b=
	NEtLmtj1+Fix4nMIhBXn5qh4Mf2U5WmukH3aKP0aiOSRWrdiBCCT7eSzgKPy3y5p
	Ak+4tdxI9CjLtFE+kn00A3D5CzFyYNa9qQEPEafjf2OsEtxKjLa3Vd9HTIEhzDmk
	lElfLDIg/lmiCW9MD4TlOqPHO1bzPDzIlP81cfD+mgDijQKeltuOlGmhX91nUG+E
	zbC57oy/WQgIMXl6ykGwjqi3Zih/nsWUHC3wIMnNJ+5S1LS6XMqj3mNLA6wEonBC
	J57kq6KKt6vYlkWMJ46gWWpmjiwnzv7bQzVCxb+PzhY/g8DHSdK70ALwTonmBGwm
	pIH8ohOF0xRjollZCcDVdw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3pdkv57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GFYLPO018222;
	Mon, 16 Sep 2024 16:54:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nycvkvnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8VEXt9F++NOqLCv+py1Ou14103tDjWN7/1JBnBDrstNE0Sy44UZJINccmImHFKkHB1buHhRmQITzOB+xkX16GGsIxZeffb8Nf48MF++6ZFJHtS6xvlqLDUSm94b/6seiioU+S7lmcddi2ebNWG+Zn2QADQP2PJu9Y4xIKJR3mMI9qEwrcz1242GGDj/U08aCr1L7ocGpY9A/TIyxWNMiYmah3kLVCwxPjoyjnULGfQbHZXKDgjlnsYt7xB15ECLl7P/ZUn7UxJqsfIzmfX+Mhspwb28itBShWhh2imtjyVMG1QSNumVHSFFjufi3boCxD/1sqQA0FdL61QmQ3dBbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wApiMeHTFOXq0txSy++5unXkrSDcIhLpYTvNPfedGE=;
 b=ZVNU7UCEb6yr/LaG//PhjW0mHqWECu9iUDt4OpPp9H+K8NV9THMWm77EF4MAr+ZjNGlk25KHw1C9QtEv1wVbhe8SzifqfoF+MaLRPH7AfWX8gd/eBBh1QKrXolpWmC2IPvyMxCDS0Ia7+AL2iXNgASxDQpd2w+FXQNhxpvyXAZEgm2FZ+H6uTYVZITEY2N9THdPQZ6tRaYEaoJtiYYQNo1780+cNjPbjg9eV9LmpwrQiTJcLB6LdSXKgLWcKmKPJar99T7oMMr7dHAQ2Q+8xtv1WQH4oVTTdGfWZI+Dip1JhAKmfKRtjKLnl1OzGf31XVnzPlavwzLhG27Sb5lIFxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wApiMeHTFOXq0txSy++5unXkrSDcIhLpYTvNPfedGE=;
 b=f7c+7m+RQDTtT233uW8a43sUXjFk+vRrROly698ZMjbsmFG/QZoS64ZL/BXSEjxpZZlwaibKXJQuUkSJxgoDusEXsL3q5KmKbyMoKib2g/M6TZ4NIKmG+hmxCIExBPphu61/RLi2DDW58ObaG5hAIdC2IzEC1kIcjXxoiS9gd2U=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:54:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.011; Mon, 16 Sep 2024
 16:54:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
        alan.adamson@oracle.com, david@fromorbit.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 3/9] pvsync2: Support RWF_ATOMIC
Date: Mon, 16 Sep 2024 16:53:41 +0000
Message-Id: <20240916165347.2226763-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0030.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::43) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 17beec70-4a5a-4f92-78cd-08dcd6703431
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lyOuRJG2d1lvQKUFPnPV4pxG4xTENXQHcE30svEHAy2b9spomTRUsWbbXOcJ?=
 =?us-ascii?Q?FATM8IiTcR6OQ//C51a8QdzSS/MbokC5Gst/+UX2lWoBg3kBKHURTxzW2iNF?=
 =?us-ascii?Q?qoXGrLtH1CYSKKWKP2+W6XT3acgRP9Ma+ZZ4FbSxux8fEMswPhwdaA5kjrjd?=
 =?us-ascii?Q?rF4Ld9g9xemmS8TkiEG16dKAMan3X2VQptyxW/NMQ5aY+1VU/BCCfwio3JtD?=
 =?us-ascii?Q?Q7p+HLIobSyhiqNnacCuCM3AI8eo0PVYReYwZfGLcUSh/+t9T8BnpstE0H7U?=
 =?us-ascii?Q?uzjAIo4E/BhWktWJrlipNu3PcnDtd9UO/+mNDKXZgM45amWue8KzR8e/b43f?=
 =?us-ascii?Q?mclOc3Q+4/E/pdkUTOzUaDo9fG8zKErVNt0fa+dX6dJt464tkXP4L/PEPhbj?=
 =?us-ascii?Q?bOKI5SeXIIUJtNAh4IicR02UqhmD0ALttL6jSbAPMCUQP7ZpVnHdMz60+gpN?=
 =?us-ascii?Q?PrMtEbZT0zhtuw1RfqiXZaRln8OdMKcpa3x1zRIi5ZVZMJINFZYf7/HEW4Z1?=
 =?us-ascii?Q?a+6vy/+mN69mEP24t696lIPg+EBpqaMIQulI/MQwvMwYjH5kSUsyCXMTU9fm?=
 =?us-ascii?Q?BioF0DsnIRslaF7kXAWq302CdhsxkVxlZF5tU+HKsev2ev4ZdgD6Q35PitFo?=
 =?us-ascii?Q?VwGCAqrgDa5y9oGT3Ut5qI+zmhzlYWRyd860qqrpsdgIMBrhXGp1xquhDEVj?=
 =?us-ascii?Q?u2pL/BhI4iin7H3XB/r2H0Jwf2f8TGq2khb+f3mUsrHrRKuvwOKD8+S1GDmy?=
 =?us-ascii?Q?RY7z7kCjGEwExGEXcUhRcwRNzQH2ACQHd9Q2GINPhFBgloA8F/BePI8D0Fkm?=
 =?us-ascii?Q?DCj9LS9KuaWO/UT/VKfZDpJrRo/dfvT9mjNYF8heJA43aIMkZDXjlRaOwbXP?=
 =?us-ascii?Q?nnJAyLMji8fARpL65jjnUgnBORuotRTOinFcV/+b9741B+f+TueoPONm57xL?=
 =?us-ascii?Q?jnzRoRWF/Uk/wkUL5MjZzEN0UPJkNXgM302Oj1EVxgzZxq+LQqPbwKTOrf1u?=
 =?us-ascii?Q?J3ONrbWJYyQ9VKElLdcgKzNJXEp4uVqkMBuoNEU0hD6pyTr67mRu88fm5NRJ?=
 =?us-ascii?Q?XY873BzfO0pT/R83iOxOwEx9efVKpG0UBtn0hEjoGDlBJ4Ki/wzFeGa2xwLm?=
 =?us-ascii?Q?uM5p6FhEQ+t2ToTfcZ4XUxuErkXmgLpnVU+RyJTOPwDECEUAMtGRtBWoxKlD?=
 =?us-ascii?Q?WHyXmzJHBJ7pOoZhRE9s1H+YzfyNhFUQkjiHpDEzQNTYCAqk2qEOVrXBkAes?=
 =?us-ascii?Q?8z0Bl63/igjYe0G8AX4M9yT+iC32BVgaKYAic00YhIx0Qt4T0w3EQqTRsapF?=
 =?us-ascii?Q?wPuUft8ZnqwXO/v9kRRbjAbtqvMrVF1aYxE6s+EkvtbJ2A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xpIUuRYVcMsjCupEEJ47P6w2tRxsJjZ6ERGKqY8JK4MZcRN7CLU4KKKU4Ubb?=
 =?us-ascii?Q?PVWVnG204ikzx+ggLlaRfwseYG67yZyTCA1Tx7cbG/lNBW45KTIbegNq/rEc?=
 =?us-ascii?Q?jVLqRTa+Frvgrl1tN/RVVieqVud8kC6KARN6PpGHUZgjdWup0hH1j62gP4oM?=
 =?us-ascii?Q?QD7GoaoeBOOMz0NgxO779AxCUikfToERHX18VOljTCBeRfNN4i3GL4rlL5Qp?=
 =?us-ascii?Q?JzwW8ii61jsRkdgjPC+3dZEXX1AdnPq65vrkCc+7Duv1L4l2ynpCl28/pwyA?=
 =?us-ascii?Q?4gN4SsfJ3fvXY8Bg9+/u99UcjXqrWYUJDeYHYTFMfzWHJNqWhL6n9rBZLuXK?=
 =?us-ascii?Q?YvNUtdk2PNndYrjcCkdhkV0Cz/7FK7Lo9pGAZpfuN4DcbYUULnbtjr9ldeuM?=
 =?us-ascii?Q?uIqU1FAq6jIkdVM42ZYTRlmxT98AQ++ZA5uk0lhxr73LHKH1nTxP+ffFldiX?=
 =?us-ascii?Q?g1R6fIRXOeVgb2dpMG6Hhj+RyrfbXNXT9Br0hi0Y4WUZ2yMXSW0Vv51j463Q?=
 =?us-ascii?Q?uIfTIGBJRL9pUDWHjr8XC9ocEtY+mu7Sl6+rtdKas2qnmMugp5i26eMXdtv+?=
 =?us-ascii?Q?TKf+IIr/JUbxAwVu7PTFZ0zV7SJUlF0XmCFk4bdBtnJljBdsnC79yCIx21D9?=
 =?us-ascii?Q?IzGuQ00PF5uhLrxJPDzuoB+E4w5Ny7ZaA2MGAFcYyyKggn8Tx+1mTIJM0zRB?=
 =?us-ascii?Q?wJ0FQsKLPxIk7vNd4zwjigwx39lT7g8HmmTNJhc2eC0SgcKAob8B2XOjG3gB?=
 =?us-ascii?Q?bvT8kmOxj7A9Lcy8cYAUkDDXex1OpS2wdKi7mtH69LtPXC+6ihtreEkNyA/5?=
 =?us-ascii?Q?usat8+xkPgBKfF1Sc+iGVLJUdSZLUphG0zDjkJ+5sLL/mlBf9RROla44jXRU?=
 =?us-ascii?Q?Lt/Y85QlzewQjF9p0FoZUVCwki74hGvMvQsVfeVR6fIJeqY84FeTo7X/3dR4?=
 =?us-ascii?Q?HBqcKKAv6kqrS6TDqeReCdK14a9cwiUy1zqBgPEGMvM83pQe6t76g9u04eAm?=
 =?us-ascii?Q?/Z0qB9/Kf6bfnICwQ+QrBmp2NWxDWY8XV/adRVr8oUnlnj8kYM5LrRqMVDdO?=
 =?us-ascii?Q?6xMa6SZBtGvxo0rBUDVT1dSlus8b+m9r1zzm8ri4TrTqAXwwIKUGLWdhc4b0?=
 =?us-ascii?Q?bvcWpNM28cKFC2fQ0BJyuYSqRPejYRP6VxPZZCduCXv+oUwZs6WQ/Bq43rAh?=
 =?us-ascii?Q?Srq2g3sCeyI5hY5jkFMLOZq4SQv/wd3EFzyLjuYtJZoAG4A2wuizVzWOItxt?=
 =?us-ascii?Q?edQ9tLpCyivQu1kwTprcRfytzssQm3Pgqjt/d5v6MzX2va2fHs3kmbYEwWLj?=
 =?us-ascii?Q?nUXvRtY+p39Pyj5VrxjiboU2HkBZemBVh6SW3RUXDD7fIqBTRgfrSZtsfayE?=
 =?us-ascii?Q?ZVdWMgtX0NMgDFOtOs07/+Ws8SrUfgSkObuq44tNd4g3+xfmscx9L0mrrmdp?=
 =?us-ascii?Q?57J+I44bbqSl2HaK9/1+rTSIdEQttlL6NrweZEb0eUEieSAKLEC1Dj14aVUF?=
 =?us-ascii?Q?2Q+pw9VYKMtcPsnoWLYHXWzVCL5PQeX0F2MxEwoFKKfXUPo2YdBuAsWXWf7K?=
 =?us-ascii?Q?AT6j83i88/13wGK2y64zXC48oYme/N56qzlFDYXHGFXgzfVRnS8G8dz5cg8g?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gktWBH+LIOl25XXSVez4xvSbbehMg8eAt1Sr4Lux4bpSn5TXJ8OfNPP1xO5e5HZNgdt+lbqLS0HPGJcXQxvW25TJbUq7IcsJTD7D5ekPE8MyKE8cCNHQutt1tRd6ElHDy3Q2A9txQIgf3eoooNpSmcfdwN1jU03RI4w9LKBLXF6r8qxhPavxuY+YTh7aJ7yYy7qdOEJGCX6D1weBTU+2ZWuvp+SgPCahjrdIFBv0Q427S+XlOb6gKTeDRTaVT+GHcLYD0Dz1qupCpYHmzOSRw37PACal2kT2lR8pLC22DudN796+nbYEI9dGuxmDDctuBJvfrmlfQLlduKZjLSfY9NDbGwDkLbquDSuJFgA/K4uisF62EsZp9RG1g5vxa2o9Gdsz+zn5vRd7AY+kn1pglhiKqkR8k7AdERwYcWNfZzb3NtndFPDu+w6Q/XqMkVVSeZBtMxDulV99/qbAxIcqUjcZCRP1v0MIuqDW5+WfLpL0S/3bnEo2nFRV2ZHOzF3rCYSCLW3psafNuV4sgX4BMLPpwHwKs+1bXWx1KFZZSOuxMSihnZ2B9bqeoeFjurSVro7FxQZY/SY0YgdlkpASu96fGY86WCaYoG79MKMCR3s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17beec70-4a5a-4f92-78cd-08dcd6703431
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:54:18.1367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovDF1FKDfhyspo+aH80eKHszEU0Y7LOjnTiaFcIJgRPxrWsWjcND9DmXy9pYMQ8dBrCh7kbzkoBQobz1p/EjJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_13,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409160112
X-Proofpoint-GUID: 7K-8RX5qiLUWXEFfOSl5N9JD7QYbJruL
X-Proofpoint-ORIG-GUID: 7K-8RX5qiLUWXEFfOSl5N9JD7QYbJruL

From: Alan Adamson <alan.adamson@oracle.com>

Set RWF_ATOMIC for writes and atomic==1.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
jpg: Set FIO_ATOMICWRITES for pvsync2
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 engines/sync.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/engines/sync.c b/engines/sync.c
index b8be4eb3..729d8a71 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -175,9 +175,11 @@ static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
 
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
@@ -476,7 +478,8 @@ static struct ioengine_ops ioengine_pvrw2 = {
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

