Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA3E140380
	for <fio@vger.kernel.org>; Tue,  4 Jun 2024 09:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717493217; cv=fail; b=gbpfpCDql5rsuE77owk8AuE/KPK8pwCov99ducgZWuXjzRVlItMq6gBzoTQVo5p/9R4RlS+7jsobGj/96GNUTH0is5nxmQC9PgD7XO+wZwy1JtpRahG959UrSyvXcCKvpoYnV/mlGTXzCfh4RZIRR/BBlP6KWzDEdNaOTHWgspQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717493217; c=relaxed/simple;
	bh=vGVwwt2h5QVwROohdVCWYHKBSTba8ah9RL14wtKniF4=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=M/W0a1wiz1IXtYlazK47wlvKB/NFOiicXwVeUri7ZWpIS8al6Hgsqh51kwdooKydy5Vp6ws5yt35ib5yhsKzvbyOtYPSWfgDIuJXaGs0/O3hoi5TIo7NugP9QXjv2pkQiBblGITpnCxme7kHmr3GxHvZtZTvjUunZquqEujmfbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJ9L5Gfm; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJ9L5Gfm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717493216; x=1749029216;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=vGVwwt2h5QVwROohdVCWYHKBSTba8ah9RL14wtKniF4=;
  b=gJ9L5GfmsAZywqxMjajcTD6Qh/fLr+2il8pSzjGHBJAwn71vh+uSZ8Wf
   5LNrA0qq+gVBof7ckhav7fmPHiymuCAZLN6YjOSDfrhWwMzR3Zwp7oglA
   qXABxZ71pPSa547PBfPzgaP65/5SXaT6GX6cjfMvLwqfuwI19LulIC/z9
   ihEBUjlF0bUnjBfnANNHofzRKCNEVfleN+IALC+o498oEx+SORmHp+GUZ
   3H0sbd8T7/ERBJhXaP8u3DFztQARP1cDySYwOjduy9Qo+7ByLpmrhjid9
   +qedY/OjijCi5CPdzcjNwy31oAu0+Uoe7dKCtBSkeYm2uZ5K0+9PD3EZM
   g==;
X-CSE-ConnectionGUID: UUYEoD5ASwakQtFL+DPBLA==
X-CSE-MsgGUID: IjoiiUBkSIa8tDagDKB9Ig==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="25429597"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="25429597"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 02:26:41 -0700
X-CSE-ConnectionGUID: /6l84+a1TUON+8hD/RUvEw==
X-CSE-MsgGUID: sKcF8EEVRPCCegVixopiDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="41640139"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jun 2024 02:26:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 02:26:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 02:26:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 02:26:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvsikl4w5nLKVWrTj9R/2siwdH+pmSOCwsJSJvrcK60E9f1f+6+RRDsY6TujzihONVLa5rThKfQISVD4iPUHQiI7Q/noF9Pi5AOhvb+PLr2Iq+daWrlTEqhobI5dGBquraFx6yhPxKjlkGaR6M7rTQaEEM3cq88XkJugkruCo9Hu7mkxzRuIsvyquwU3+aia3+T+td5OTG0wvhwI35lsja1vhTlP2SotVU+4Elzwm+F6YYK/En1K1oJlTKXY3nCd3/xDW+ppDZE395GB6cnxZpXvZ54+Swq9PZUgiOhSH8/w+9E00eFrD5PG2/P+xNpLejwEuxyPHwiRZtaTvtlCOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9aPC4yhr429muCc/6OBquxJHl336KL45UC4TUxw4S0=;
 b=RZcDEsz1Z672UW/zbPaQ/O2umtLRHf6ULKLQKbCPTnOLUZNz646pRVHMiUaxDd+wf6PnzXBZdK4QaLoFoRxk1IOmlEWowI9erD/BAUSdX3KP98Yv77VFcXdIRB1iUg0hsDYrgZlnA9ScJ4xugM3y5/ECwQSZ3+QAnU83p/hjEQDzSXYz1yjVtP2GHAHX/UItg732itPfmZjJBUC2jlu7ZHi5Kmti0x+9AHrmj0vNgxRK8WY+NZE3iVJ+8cHqCJjyIn0mF13vakVAOw1oTTOKkdfFNQODq4RKmh0FXgeEqJwy6U8TTgZZGJyiJKP1j1MYO3xGkkjIxjAKhkWSiMpaTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5159.namprd11.prod.outlook.com (2603:10b6:510:3c::20)
 by PH0PR11MB5016.namprd11.prod.outlook.com (2603:10b6:510:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Tue, 4 Jun
 2024 09:26:32 +0000
Received: from PH0PR11MB5159.namprd11.prod.outlook.com
 ([fe80::e7aa:f8cd:6386:5562]) by PH0PR11MB5159.namprd11.prod.outlook.com
 ([fe80::e7aa:f8cd:6386:5562%6]) with mapi id 15.20.7633.018; Tue, 4 Jun 2024
 09:26:32 +0000
From: "Berger, Michal" <michal.berger@intel.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: cpus_allowed impact under newer linux kernels
Thread-Topic: cpus_allowed impact under newer linux kernels
Thread-Index: Adq2WEQtY24cNk9mQ2ag8dybCKxvcg==
Date: Tue, 4 Jun 2024 09:26:32 +0000
Message-ID: <PH0PR11MB5159DFC65BB5AAAC32FFDE0FE6F82@PH0PR11MB5159.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5159:EE_|PH0PR11MB5016:EE_
x-ms-office365-filtering-correlation-id: a2e46fff-0207-4972-871f-08dc84786c2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?Xl3bW6ykkXNjWXvivYUcB25rE+4ouzZ1J1O7tSYLSpM+pDx7kZsho+qA1nSS?=
 =?us-ascii?Q?P2FRB9WkU4LmBU/UTpVMJIsUR7tbsdJ65ckMTqlY1b6aEx6k8EMKSKYXGoRZ?=
 =?us-ascii?Q?fZRTPAb0yzZq+S8qtaT1kqgLLn0FbfhYx1ua6rvDLwMBdcV5n8IJAZIHz4Oo?=
 =?us-ascii?Q?g8ew4TNyorQUXucxm8YiSs1TNjFuTbWuxKIvCTE/VfcQK50LULNejkfFnPlF?=
 =?us-ascii?Q?LYZnZUxmFDCfcGmXGMRNsacLKTuLz/hig7OOFonoZjfoQGvDQZTKQm/5jsj2?=
 =?us-ascii?Q?y06luIc/4WiwbKDRcNF6TRFy4Bpz9xvVdVdqLnBpwfkuFkDR3riFcypKIAX+?=
 =?us-ascii?Q?h39mkhKcKhxvE7XBrHXEu0VR9PpfbQGrDf+lVpH762jtIw/chlkhYvH2TCxi?=
 =?us-ascii?Q?QbGsdzFG8lSes6YQpatixnfdIKMnNu/T8uLLxT/raDuPTk/8kI4zr0Hf7uCz?=
 =?us-ascii?Q?yvq2B12YOlY6dUzTdu+8Dp8+Pns8PkbqDIRTaMQWykpjpRKxfPD+jXXqIMPl?=
 =?us-ascii?Q?4FEDmNL9zHDbR22gh111myDqmZ0S5PGL3jKdZmTzXtAHU/ggER2OFLGr4df9?=
 =?us-ascii?Q?W42WsPe8OzFTRCbBUREb9vl3z2R3E8sYe/zIZ1wVYTa+TBe4f6TzJdv9m/GM?=
 =?us-ascii?Q?Dz5wi1hNDa9fk3OSsthqX/ZcP55ofPUBxXcUsdNCtPMqf/DyRNjr8K7eije7?=
 =?us-ascii?Q?ID8dUorW5UgePsackKm26a/zj/9Nq6KJS2AUP88b6hpNQzMor0X7AShHrd8U?=
 =?us-ascii?Q?E371DKNg/cn+/cjFMXo9ZcbPlRbSkRoWrF9ZLatLc48Yrihy0nPveUM6Xi2/?=
 =?us-ascii?Q?i3eQwQDoqoumpcc0anh32vJPSA/Y3EuZYt/bmdFIAdOlh+JoN4S1QfJ4aof4?=
 =?us-ascii?Q?3cuawBiTQvWN5mwn3YM1r3JcAXIQajYP/1tZU48DdC9N8L2KshZkse1GvtaU?=
 =?us-ascii?Q?uwfLn91WpwZJWlVTjJwcwdfLCwbMpjIVgWwagslDFzD+0CniT8enokuzdYX2?=
 =?us-ascii?Q?GRMF3QqvYDzqBOkMeL8m25FwOzirUnA5foZpPy8cmnPTqdOagZ5UdUk0chHZ?=
 =?us-ascii?Q?b1bsBuD3rtmlDTBLZn+JbdAHWuboUocv+00E3VixZFFp57ygV3SHrkjpmswn?=
 =?us-ascii?Q?asjnAU5KaSu0H/B8wiafkjWz44WmuCHwMUQZ2zcVvZhanaAjM6UMu+y4P1dX?=
 =?us-ascii?Q?ra/brn1g9nm+DE4pmkPUG4/Wa33SujpQBj0/fiuvu62g8GZGrDNYOVhVuQqp?=
 =?us-ascii?Q?29+3wtdfaE0IJO3YL4RUKFDUeSFyp7zyOmVL0I61nWb2+2WIZLrYVBT64KvM?=
 =?us-ascii?Q?msKaOTur+zvMph0uXlVL+fMI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5159.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FhEG0pwMMLYNqguYvl6sR7DphEy39Hzt/2CNkY5NAhiQ42nLbB8NgmZRF+Yw?=
 =?us-ascii?Q?c6S3AzpIuo0u3hfB+LXI+V03O9b/w4n6i6MOHoz8xTw+wXRCxgh4zItxrEZ/?=
 =?us-ascii?Q?nBjRpLQFCWK9Qs5etrgi2DGihUzL14qxtLy3bRVVAz7r1zKhuY1BQrJXVsuV?=
 =?us-ascii?Q?Jwv6n24FAUyHX39deyleIEvVnR7QnWmksOHuycUAGZ0ABsSdN4nUuCFf6Aeb?=
 =?us-ascii?Q?T5yTLn6pRJqj2vWqjtWy37UBizy5f6AtXOx3Xm5DvUcgVlnphTzh3fAnVujZ?=
 =?us-ascii?Q?XKB/Xvk3lFLokawZiDO1S6gxZcTayLF7qsFaAeEkMtQSma4kOOcGxUeOSLN7?=
 =?us-ascii?Q?u5HFbWJcOSbxIJyQmX8l/9ab2hJYPlNYGbFlHB0uYl76i+Z8Mq5TB4NZNq+s?=
 =?us-ascii?Q?mADk9GC6xncbg2UQbmkUPVUdtXCKGRtd9S66+2UHqjYN8JezTlQMwguboSQC?=
 =?us-ascii?Q?csq+zzK5tTQAKiNhjKXPBBxfWq44aWvyOOt2sFIo64bPDLAthRGIgOQTcFmj?=
 =?us-ascii?Q?xDD+FAJORk9QslC1kugdyWnlSLPimTGh8gvUKnO5MHBr3Q5FLBjZlmacJ4Eb?=
 =?us-ascii?Q?GU/S6TnyUuIr9b2HnF6Yhp+9/S9zKg7vTNKo6kH7FmsRe/o31e5mrwLY7tzG?=
 =?us-ascii?Q?hidExmYYFlSmn7Ow/2CamjHJWFzVS7ntIGx8MOiYH+DmzpA3o/ePRlXtimtx?=
 =?us-ascii?Q?WaDl9jR49Ug7CBChWOQ4xBRfSJ3sMDRKfMWSPDQ9xvf30E9hUBcsMpFC/UIq?=
 =?us-ascii?Q?pldcEYCJ30aGvne9eNUY3EElM+C3sg9cEaceDeRXy/Gdo6oNmdn3hBfmhe/4?=
 =?us-ascii?Q?LlMHGL6KM7WvNE04lO0VqUxllOvb71W+Isx/gwT3aNUABeK5NuLgXVVvceoc?=
 =?us-ascii?Q?w2kcpDPwgqckIEqa1zBkblm/6NAWMWHE+1I+s0+Pv1KSAlyd7rJL1K3vbcxL?=
 =?us-ascii?Q?iRrx458NyFxtNgwLvSbLDj1rad9tV5kG9FBSiwxH1kvpfAjvCov4ga9sbEEn?=
 =?us-ascii?Q?A8FUgMM095fa1ikLEL4Fh2vagdmENMcBsnMFJQhpO51WgFpmU+53syq3TAuQ?=
 =?us-ascii?Q?7fOZ+wxR1I5CsTkU+tx3tWNPzktscSqcVG986pGL9haHYmT0MJKWSLwRTx/E?=
 =?us-ascii?Q?R2mjVPuQW3241nGIo/OsVBxfSuf9t8gDUeSNIVOkueVB256ZthB2S7ciAeAC?=
 =?us-ascii?Q?bWdt1KFA6Djx1Ngvv/qRRqUWagN9svMRBoUFvNdOytqDSNnPtTGPJd7n5USY?=
 =?us-ascii?Q?PJEGh4TLe5rXCtt6tkqFY8ZQDoEihbCXPVOKQN4VAV12t96BPzS6y/I9ctTb?=
 =?us-ascii?Q?3SoBbNkDTr030oSKkSZt2+NXN3hy9nPU+nyFLf2cGojqdE8JWyfiKwtMtaTc?=
 =?us-ascii?Q?UGVYeaAD5jHUJgxdeu4vCWT30d9lwdV3/4VDhc29+F3xrVYwEMKaKnCAZCh5?=
 =?us-ascii?Q?jpaQZyrEIIjIfPArbq2RAPjme2yYmj/NtL6VQwP9otbYrDixn4mPtCiPvzcj?=
 =?us-ascii?Q?E+1zbEfM8MFeHdACGDfdHKJasX/Q0/YOjX1gu31xiqArHoxetpPKT/lMZ7ps?=
 =?us-ascii?Q?JeCQ4gVfSpKuEGeDDzhUjBSvLh1uShTF4i+ghav6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5159.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e46fff-0207-4972-871f-08dc84786c2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2024 09:26:32.5366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Jyb4OjG1e29xk/v+uNJnfYCcqB65VD0W7gyix5Q6vBX7A0U2o61S578OSOeLym86K6JdF14HSqiu9FgshSd4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5016
X-OriginatorOrg: intel.com

```
fio: fio-3.28, fio-3.35, master
linux kernel: 6.8.9 (fedora38)
ioengine: io_uring
```
Please, consider this issue as a question and bear with me as I am trying t=
o understand changes in the io workloads between the kernels - your feedbac=
k on the bellow would be greatly appreciated.=20

It seems that the impact of the `cpus_allowed` changed, following related c=
pu affinity changes in the kernel regarding the `iou-{sqp,wrk}-*` threads. =
 To my understanding, under older kernels, e.g. 6.1,
the `iou-sqp` threads were being pinned to ALL online cpus, where `iou-wrk`=
 ones to online cpus of given numa node (in relation to the placement of th=
e job's thread). This changed, e.g. under 6.8, such that
all these threads are now pinned to cpus listed under `cpus_allowed`. This =
seems to impact the performance, since for the following minimal `io_uring`=
 setup:

```
[global]
direct=3D1
thread=3D1
norandommap=3D1
group_reporting=3D1
time_based=3D1

rw=3Drandread
rwmixread=3D70
bs=3D4096
ramp_time=3D0
numjobs=3D1
log_avg_msec=3D0
fixedbufs=3D1
hipri=3D1
registerfiles=3D1
sqthread_poll=3D1

[filename0]
iodepth=3D1
cpus_allowed=3D15  # node1
filename=3D/dev/nvme0n1 # numa_node=3D1
```
It drops quite significantly compared to 6.1 kernel:

6.8:
```
 $ fio ./fio.conf --ioengine=3Dio_uring --runtime=3D5
filename0: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D1
fio-3.28
Starting 1 thread
Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D504KiB/s][r=3D126 IOPS][eta 00m:00s]
filename0: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6697: Thu May 23 11:34:=
54 2024
  read: IOPS=3D125, BW=3D501KiB/s (513kB/s)(2508KiB/5005msec)
    clat (usec): min=3D5006, max=3D13999, avg=3D7980.23, stdev=3D955.42
     lat (usec): min=3D5007, max=3D13999, avg=3D7980.41, stdev=3D955.41
    clat percentiles (usec):
     |  1.00th=3D[ 6980],  5.00th=3D[ 6980], 10.00th=3D[ 6980], 20.00th=3D[=
 7046],
     | 30.00th=3D[ 7963], 40.00th=3D[ 7963], 50.00th=3D[ 7963], 60.00th=3D[=
 8029],
     | 70.00th=3D[ 8029], 80.00th=3D[ 8029], 90.00th=3D[ 8029], 95.00th=3D[=
10945],
     | 99.00th=3D[11076], 99.50th=3D[11076], 99.90th=3D[13960], 99.95th=3D[=
13960],
     | 99.99th=3D[13960]
   bw (  KiB/s): min=3D  488, max=3D  504, per=3D99.78%, avg=3D500.44, stde=
v=3D 7.06, samples=3D9
   iops        : min=3D  122, max=3D  126, avg=3D125.11, stdev=3D 1.76, sam=
ples=3D9
  lat (msec)   : 10=3D93.46%, 20=3D6.54%
  cpu          : usr=3D49.74%, sys=3D0.00%, ctx=3D631, majf=3D0, minf=3D10
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0=
.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D627,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D501KiB/s (513kB/s), 501KiB/s-501KiB/s (513kB/s-513kB/s), io=
=3D2508KiB (2568kB), run=3D5005-5005msec

Disk stats (read/write):
  nvme0n1: ios=3D614/0, merge=3D0/0, ticks=3D167/0, in_queue=3D167, util=3D=
12.29%
 ```
cpu affinity:
```
# grep Name /proc/$(pgrep fio | tail -n1)/task/*/status
/proc/6856/task/6856/status:Name:       fio
/proc/6856/task/6857/status:Name:       fio
/proc/6856/task/6858/status:Name:       fio
/proc/6856/task/6859/status:Name:       iou-sqp-6858
# grep Cpu /proc/$(pgrep fio | tail -n1)/task/*/status
/proc/6856/task/6856/status:Cpus_allowed:       3fffffff
/proc/6856/task/6856/status:Cpus_allowed_list:  0-29
/proc/6856/task/6857/status:Cpus_allowed:       3fffffff
/proc/6856/task/6857/status:Cpus_allowed_list:  0-29
/proc/6856/task/6858/status:Cpus_allowed:       00008000
/proc/6856/task/6858/status:Cpus_allowed_list:  15
/proc/6856/task/6859/status:Cpus_allowed:       00008000
/proc/6856/task/6859/status:Cpus_allowed_list:  15 # <- iou-sqp

```
6.1:
```
$ fio ./fio.conf --ioengine=3Dio_uring --runtime=3D5
filename0: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D1
fio-3.28
Starting 1 thread
Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D102MiB/s][r=3D26.0k IOPS][eta 00m:00s]
filename0: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3356: Thu May 23 11:37:=
17 2024
  Description  : ["Test io_plugin=3Dkernel-io-uring Blocksize=3D4096 Worklo=
ad=3Drandread MIX=3D70 qd=3D1024"]
  read: IOPS=3D25.9k, BW=3D101MiB/s (106MB/s)(506MiB/5001msec)
    clat (usec): min=3D32, max=3D26382, avg=3D38.22, stdev=3D74.23
     lat (usec): min=3D33, max=3D26385, avg=3D38.32, stdev=3D74.24
    clat percentiles (usec):
     |  1.00th=3D[   35],  5.00th=3D[   36], 10.00th=3D[   36], 20.00th=3D[=
   37],
     | 30.00th=3D[   37], 40.00th=3D[   37], 50.00th=3D[   37], 60.00th=3D[=
   38],
     | 70.00th=3D[   38], 80.00th=3D[   39], 90.00th=3D[   41], 95.00th=3D[=
   47],
     | 99.00th=3D[   65], 99.50th=3D[   68], 99.90th=3D[   87], 99.95th=3D[=
   94],
     | 99.99th=3D[  155]
   bw (  KiB/s): min=3D92384, max=3D106776, per=3D99.84%, avg=3D103344.00, =
stdev=3D4395.69, samples=3D9
   iops        : min=3D23096, max=3D26694, avg=3D25836.00, stdev=3D1098.92,=
 samples=3D9
  lat (usec)   : 50=3D96.37%, 100=3D3.60%, 250=3D0.03%, 500=3D0.01%, 750=3D=
0.01%
  lat (msec)   : 4=3D0.01%, 50=3D0.01%
  cpu          : usr=3D99.50%, sys=3D0.00%, ctx=3D7, majf=3D0, minf=3D20
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0=
.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D129413,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D101MiB/s (106MB/s), 101MiB/s-101MiB/s (106MB/s-106MB/s), io=
=3D506MiB (530MB), run=3D5001-5001msec

Disk stats (read/write):
  nvme0n1: ios=3D126698/0, merge=3D0/0, ticks=3D4649/0, in_queue=3D4649, ut=
il=3D97.58%
```
cpu affinity:
```
# grep Name /proc/$(pgrep fio | tail -n1)/task/*/status
/proc/3361/task/3361/status:Name:       fio
/proc/3361/task/3371/status:Name:       fio
/proc/3361/task/3372/status:Name:       fio
/proc/3361/task/3376/status:Name:       iou-sqp-3372
# grep Cpu /proc/$(pgrep fio | tail -n1)/task/*/status
/proc/3361/task/3361/status:Cpus_allowed:       3fffffff
/proc/3361/task/3361/status:Cpus_allowed_list:  0-29
/proc/3361/task/3371/status:Cpus_allowed:       3fffffff
/proc/3361/task/3371/status:Cpus_allowed_list:  0-29
/proc/3361/task/3372/status:Cpus_allowed:       00008000
/proc/3361/task/3372/status:Cpus_allowed_list:  15
/proc/3361/task/3376/status:Cpus_allowed:       3fffffff
/proc/3361/task/3376/status:Cpus_allowed_list:  0-29 # <- iou-sqp

```
In order to align the results between the kernels, setting a separate cpu (=
keeping it under the same node) for the sqpoll thread under 6.8 seems to he=
lp:
```
filename0: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D1
fio-3.28
Starting 1 thread
Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D120MiB/s][r=3D30.8k IOPS][eta 00m:00s]
filename0: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6912: Thu May 23 11:47:=
13 2024
  read: IOPS=3D30.5k, BW=3D119MiB/s (125MB/s)(596MiB/5001msec)
    clat (usec): min=3D4, max=3D3588, avg=3D32.37, stdev=3D 9.64
     lat (usec): min=3D29, max=3D3590, avg=3D32.46, stdev=3D 9.65
    clat percentiles (usec):
     |  1.00th=3D[   31],  5.00th=3D[   31], 10.00th=3D[   32], 20.00th=3D[=
   32],
     | 30.00th=3D[   32], 40.00th=3D[   32], 50.00th=3D[   32], 60.00th=3D[=
   33],
     | 70.00th=3D[   33], 80.00th=3D[   34], 90.00th=3D[   34], 95.00th=3D[=
   35],
     | 99.00th=3D[   44], 99.50th=3D[   50], 99.90th=3D[   78], 99.95th=3D[=
   82],
     | 99.99th=3D[  106]
   bw (  KiB/s): min=3D117800, max=3D123400, per=3D100.00%, avg=3D122219.56=
, stdev=3D1871.89, samples=3D9
   iops        : min=3D29450, max=3D30850, avg=3D30554.89, stdev=3D467.97, =
samples=3D9
  lat (usec)   : 10=3D0.01%, 50=3D99.50%, 100=3D0.48%, 250=3D0.01%, 500=3D0=
.01%
  lat (msec)   : 4=3D0.01%
  cpu          : usr=3D99.70%, sys=3D0.00%, ctx=3D15, majf=3D0, minf=3D12
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0=
.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D152702,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D119MiB/s (125MB/s), 119MiB/s-119MiB/s (125MB/s-125MB/s), io=
=3D596MiB (625MB), run=3D5001-5001msec

Disk stats (read/write):
  nvme0n1: ios=3D149569/0, merge=3D0/0, ticks=3D4662/0, in_queue=3D4662, ut=
il=3D98.06%
```
cpu affinity:
```
# grep Name /proc/$(pgrep fio | tail -n1)/task/*/status
/proc/6914/task/6914/status:Name:       fio
/proc/6914/task/6915/status:Name:       fio
/proc/6914/task/6916/status:Name:       fio
/proc/6914/task/6917/status:Name:       iou-sqp-6916
# grep Cpu /proc/$(pgrep fio | tail -n1)/task/*/status
/proc/6914/task/6914/status:Cpus_allowed:       3fffffff
/proc/6914/task/6914/status:Cpus_allowed_list:  0-29
/proc/6914/task/6915/status:Cpus_allowed:       3fffffff
/proc/6914/task/6915/status:Cpus_allowed_list:  0-29
/proc/6914/task/6916/status:Cpus_allowed:       00008000
/proc/6914/task/6916/status:Cpus_allowed_list:  15
/proc/6914/task/6917/status:Cpus_allowed:       00010000
/proc/6914/task/6917/status:Cpus_allowed_list:  16 # <- iou-sqp
```

Essentially, when the `io-sqp` thread is kept on the same cpu as job's thre=
ad, the cpu load seems to be split in half. So it would seem that setting s=
eparate cpu for these threads is the way to go.

However, for a bare-metal setups, simply selecting a separate cpu for the s=
qpoll thread doesn't help to align the results between 6.1, 6.8 fully. here=
's an example of a setup with 22 nvmes.
Each job is pinned to a cpu|nvme matching the same numa node placement, smt=
 is enabled, the `sqthread_poll_cpu` is set to a sibling thread of the `cpu=
s_allowed` cpu (so essentially each job should be bound
to a single physical core). Each nvme block device has the following config=
: nomerges=3D2,iostats=3D0,rq_affinity=3D0,io_poll_delay=3D-1.

```
[global]
direct=3D1
thread=3D1
norandommap=3D1
group_reporting=3D1
time_based=3D1

rw=3Drandread
rwmixread=3D70
bs=3D4096
ramp_time=3D0
numjobs=3D1
log_avg_msec=3D0
fixedbufs=3D1
hipri=3D1
registerfiles=3D1
sqthread_poll=3D1

[filename0]
iodepth=3D2048
cpus_allowed=3D0=20
sqthread_poll_cpu=3D56
filename=3D/dev/nvme0n1=20
filename=3D/dev/nvme1n1

[filename1]
iodepth=3D2048
cpus_allowed=3D1=20
sqthread_poll_cpu=3D57
filename=3D/dev/nvme2n1=20
filename=3D/dev/nvme6n1=20

[filename2]
iodepth=3D2048
cpus_allowed=3D2=20
sqthread_poll_cpu=3D58
filename=3D/dev/nvme8n1=20
filename=3D/dev/nvme9n1=20
[filename3]
iodepth=3D2048
cpus_allowed=3D3
sqthread_poll_cpu=3D59
filename=3D/dev/nvme10n1=20
filename=3D/dev/nvme12n1=20

[filename4]
iodepth=3D2048
cpus_allowed=3D4=20
sqthread_poll_cpu=3D60
filename=3D/dev/nvme11n1=20
filename=3D/dev/nvme17n1=20

[filename5]
iodepth=3D2048
cpus_allowed=3D5=20
sqthread_poll_cpu=3D61
filename=3D/dev/nvme3n1=20
filename=3D/dev/nvme4n1=20

[filename6]
iodepth=3D2048
cpus_allowed=3D28=20
sqthread_poll_cpu=3D84
filename=3D/dev/nvme5n1=20
filename=3D/dev/nvme7n1=20
[filename7]
iodepth=3D2048
cpus_allowed=3D29=20
sqthread_poll_cpu=3D85
filename=3D/dev/nvme13n1=20
filename=3D/dev/nvme14n1=20

[filename8]
iodepth=3D2048
cpus_allowed=3D30
sqthread_poll_cpu=3D86
filename=3D/dev/nvme15n1=20
filename=3D/dev/nvme16n1=20

[filename9]
iodepth=3D2048
cpus_allowed=3D31
sqthread_poll_cpu=3D87
filename=3D/dev/nvme18n1=20
filename=3D/dev/nvme19n1

[filename10]
iodepth=3D1024
cpus_allowed=3D32=20
sqthread_poll_cpu=3D88
filename=3D/dev/nvme20n1=20

[filename11]
iodepth=3D1024
cpus_allowed=3D33=20
sqthread_poll_cpu=3D89
filename=3D/dev/nvme21n1=20
```

The results look like this:
```
filename0: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename1: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename2: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename3: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename4: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename5: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename6: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename7: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename8: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename9: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D2048
filename10: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D1024
filename11: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D1024
fio-3.37-31-gd3bc
Starting 12 threads
Jobs: 12 (f=3D22): [r(12)][100.0%][r=3D49.6GiB/s][r=3D13.0M IOPS][eta 00m:0=
0s]
filename0: (groupid=3D0, jobs=3D12): err=3D 0: pid=3D46722: Thu May 23 11:5=
5:55 2024
  Description  : ["Test io_plugin=3Dkernel-io-uring Blocksize=3D4096 Worklo=
ad=3Drandread MIX=3D70 qd=3D1024"]
  read: IOPS=3D13.0M, BW=3D49.6GiB/s (53.2GB/s)(248GiB/5002msec)
    clat (usec): min=3D289, max=3D3547, avg=3D1733.33, stdev=3D463.63
     lat (usec): min=3D290, max=3D3547, avg=3D1733.41, stdev=3D463.63
    clat percentiles (usec):
     |  1.00th=3D[  693],  5.00th=3D[  783], 10.00th=3D[  832], 20.00th=3D[=
 1713],
     | 30.00th=3D[ 1811], 40.00th=3D[ 1844], 50.00th=3D[ 1860], 60.00th=3D[=
 1893],
     | 70.00th=3D[ 1926], 80.00th=3D[ 2024], 90.00th=3D[ 2180], 95.00th=3D[=
 2278],
     | 99.00th=3D[ 2442], 99.50th=3D[ 2507], 99.90th=3D[ 2606], 99.95th=3D[=
 2671],
     | 99.99th=3D[ 2900]
   bw (  MiB/s): min=3D50324, max=3D50952, per=3D100.00%, avg=3D50769.42, s=
tdev=3D15.79, samples=3D108
   iops        : min=3D12883193, max=3D13043864, avg=3D12996971.44, stdev=
=3D4041.62, samples=3D108
  lat (usec)   : 500=3D0.03%, 750=3D3.06%, 1000=3D15.14%
  lat (msec)   : 2=3D60.21%, 4=3D21.56%
  cpu          : usr=3D99.61%, sys=3D0.01%, ctx=3D127, majf=3D0, minf=3D545=
3
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued rwts: total=3D64977031,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1024

Run status group 0 (all jobs):
   READ: bw=3D49.6GiB/s (53.2GB/s), 49.6GiB/s-49.6GiB/s (53.2GB/s-53.2GB/s)=
, io=3D248GiB (266GB), run=3D5002-5002msec

Disk stats (read/write):
  nvme0n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme1n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme2n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme6n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme8n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme9n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme10n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme12n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme11n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme17n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme3n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme4n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme5n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme7n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%
  nvme13n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme14n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme15n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme16n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme18n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme19n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme20n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
  nvme21n1: ios=3D0/0, sectors=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D=
0, util=3D0.00%
```
We cap at ~13M IOPS (without the separate cpu for the poll threads we cap a=
t < 1M IOPS). However, the same setup (without the `sqthread_poll_cpu`) und=
er the 6.1 kernel yields
~20M IOPS.=20

The interesting part is that, under 6.8, if we move the sqpoll thread to a =
completely different core (see note above about the smt) then the results g=
o back to ~20M IOPS.

So I guess my question is if all the above is expected and indeed users sho=
uld start using separate cpu cores for the sqpoll threads under newer kerne=
ls?=20

Another observation is that number of these sqpoll threads is bound to `num=
jobs`, however, there's no way to define separate cpus for separate sqpoll =
threads. So, for instance,
`numjobs=3D4` would create 4 sqpoll threads bound to a single `sqthread_pol=
l_cpu` for given job. I am guessing this too may impact the performance ins=
 some way, especially
considering that under older kernels these threads were pinned to every onl=
ine cpu.

Regards,
Michal

