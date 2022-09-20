Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376D9C6FA82
	for <fio@archiver.kernel.org>; Tue, 20 Sep 2022 18:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiITSIh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 20 Sep 2022 14:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiITSIf (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Sep 2022 14:08:35 -0400
Received: from CAN01-YT3-obe.outbound.protection.outlook.com (mail-yt3can01on2133.outbound.protection.outlook.com [40.107.115.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B240659D4
        for <fio@vger.kernel.org>; Tue, 20 Sep 2022 11:08:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDIpZoW/2+z/QliiwJVoaJJUb5xOUUzecI7AfbDAgaKrdQ+I9R66DRiAKayEXO4rIlSOS0eCGOi7d0neyhqj+h190/q0fRPnMsPG6BKLvCdvu98T0elAkaYGnQh+rIIv4LQ9Em+CZwSvwe49QJhsm4L2CDUbdH5Ag+AUiWMbFeK9idStLSxrbt3r/PAja2Z13KFNs7cq2oPyFLW6mM5A4jQvUn2wNQqZUXVg08LFVEmqbLtqwNq9+LH72z77znbNlDmYkex7tEGadsoz/C2clUBYWI8R61eW4PWxbP/VD3T2sZo90GzWQ/zUc1mIFyVrmmRT9LdWpw7XjU2ELXhghQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mst7ep8z4SiocjDAhNfr3GCxDyfETtTDurFd6h8Nuqs=;
 b=EKovWK1hMZPGJM0TinGGmns8fa07C4HsZz//9HsjmAdk4FUaaDgL5NWPHMLRf+2VkhU7RlZxGqcjjiCn9H5/eBl1Tkp+wXyUpZBqpHnRmv1ZyXTmYsLnaUjgYeWr+Oazuyp5zoVMVvgeooWTGAfYDmAu2Jwp/TNuuwVhexHmpN7uMhGWXKCm8pR9Vm7vFObDdxVllYr6PXTrbL3CdOL8KUKV05e3PiMafA24n9cn2U03Dscr4VBbU2ejeyZYMk5b9v3wko82eF01weZA1+I66ikO5ypgXfLDmkiShwaKrxqEU69X/2KaDT1l20ovXj17ZIsJ9CNogfS6uqVbedTcYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mst7ep8z4SiocjDAhNfr3GCxDyfETtTDurFd6h8Nuqs=;
 b=oNYA72pYtSA53AHLXo9UErBUry69PXO/TsGhcwv0RZSifEEt3Bdn6W/QYMWFWHcqt5YipVaHS4OoJ1B2Zg+Bmzq6x7EeRHu5f5jTrt11HoNjjsvFvVgeOLKQb3wSTlESlqIn6IUimzTg0ci1tLs+TXS1Tn8FrC07FR/Wq7gpcIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1e::7)
 by YT1PR01MB9100.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:cf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Tue, 20 Sep
 2022 18:08:33 +0000
Received: from YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::9039:e2f5:7fca:c6ed]) by YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::9039:e2f5:7fca:c6ed%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 18:08:32 +0000
Date:   Tue, 20 Sep 2022 18:08:29 +0000
From:   Stephen Bates <sbates@raithlin.com>
To:     fio@vger.kernel.org
Subject: Project to standardize on IOPS per CPU core
Message-ID: <YyoBne389mzhCT8J@ip-172-31-63-112.us-west-2.compute.internal>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-ClientProxiedBy: MW4PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:303:6a::22) To YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQXPR01MB4435:EE_|YT1PR01MB9100:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ead93ab-8082-4a9f-27fb-08da9b33211e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VU87J+j2cqq8JLDEgmpILaH+yMKNXSbaaluzY69MQeim+AWmGp3MJL4v8XAbb0Jr7izrDvaeee9j6Xi8m1viUVfHYDXJzDFGYQxVwfpyELEbD0FKJSvy5ANyNVjMH7stF4AbiQOfuF8kaB8/B5O2Vto2qPG9dhkC7R2BxrKmi8FjRYn/ZNus5zrVJm2MXvnFpuo/doW4YEV+SLeXlgbFXqKvOFVvNTEK8a2Bd7YTPMWMEdGARlDB+ZbWitSNdLniRRMXpZJaVjj9I6dSjVE8HrQ/HoQt7joA+PkPU8UsjLdrHscIZfg7QA52/i1YKr4xMgPXRZtHJOBNs6qAM6L5+nHg48d1k9wxQm1uqyccA2OOiR89jFLM7GS0YWMh4A50Uup0QwoCBTK0NptJX3BLt/s3D0lo9A4kRDDAOQhj9RceMCzJBIwtQHqtOlvcjjf1nZADhw3TbsQSyEETkWSdhAbu/gHdSklrl3FbKWAFrYC3fJuLp3P7/x9azChoNSDg5cvk5hD6JmexV+rCDLX97xWXOtFzr4EzYEjocdH2LKYLQZQHnq/SC0NNpTbhIef4ALOEJaMNfDLZijptBXJ6rZ/ASKz8I3YGXyx3jfI1SVjCrjqH4IKRUIx4EKOEOM0Y2nyDsMvK1myhghsX1tWo78Frj8muvjIxbrharqSGjTE49eMm4ZnhmswI2PMLMPYH9PdW+c8qcyCxRJPrKkxf8s+p74sZORQms3UbnLm8bAA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39830400003)(366004)(136003)(376002)(451199015)(6506007)(86362001)(41300700001)(6666004)(8936002)(26005)(66476007)(66556008)(966005)(6486002)(478600001)(8676002)(66946007)(6916009)(186003)(316002)(2906002)(5660300002)(9686003)(6512007)(38100700002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmR2N09ia2JCY0pWVTBGekxHYTRHM3hmbFdmRlpaS3NGeHBiU3RMc1hJaGQx?=
 =?utf-8?B?Y2tqVkhBVVBWNGdYWGJWZ2xIaDkyaUR0bFVKeHU5QWhkSXJldEpDK1dFUFBY?=
 =?utf-8?B?a1hxYWI5ajdydVZEQVJ5V0xhUWdBdStUc2Rla2JsdlZTT0E4QnhMWnh5WXRD?=
 =?utf-8?B?TG1QN0w3SmlZSE0wcGJjYjVVUFg4WllLVWVEM0VhN0hrZzU2Z3pDNERGZmV0?=
 =?utf-8?B?ZkIwenRIems4RU0rYitvMDFKbGVBYXVaNkFhTEE0dkZORXRCckZzMkdScHdF?=
 =?utf-8?B?UTVXQ3hWRjQxeGZWa3F5NytmanpOS3BGNTBjN2wxZU96VEhhNmRoSWhQT2pD?=
 =?utf-8?B?Rk1CY2VPZlMxOTRFbFVVZzNwN3hMRzN0dDlZb2RVM1d0YlU0eERTMFhxOWQy?=
 =?utf-8?B?Y3d5M2FRQmZYYnFXLzB4UldpVVNTUm81cVFBUUpGODl3ajQwejdQMnBWS3lq?=
 =?utf-8?B?SzJvcFNqR0tjbUtmeW9sbUowSFdOVkJnYzdXOCtuV2JZNkJSa0ZvNFlMMCtO?=
 =?utf-8?B?U3ZHUUN0cEU3VC9SRkQ5Y2g0RTZpSEIrT080eFpRQ0VORDV1L2hQNHYxZnpo?=
 =?utf-8?B?L3BjeTh0VCtkY1cwWlFPMmJGcUJKM0d6Y08rUzM3K0NrblppVjQ1RUx4b0VS?=
 =?utf-8?B?YTFNT2NDU0VkTkVaTnE2Qm5Pdlg3c2hFTDNDU0UyaGo0R0xaWVdvb2tOd1Vo?=
 =?utf-8?B?RjBaWE9YOFNjZk1WbWF4SXRtL1ZZcFFWRUdNZExSZmV5cVBhMGtOUVYyRjd3?=
 =?utf-8?B?b3VnSS9LRkw2RE1XVjVHaG9tRGlOQ2g4Zk9XMjBSdUJRZGJkU2M3TjU3WFZi?=
 =?utf-8?B?Q2YzZ1REVW5KT2l4RldxT0Q1SXpXQWNHSkZDSDFaZHA4anhhSUdjQWdxczBT?=
 =?utf-8?B?emNORTlkRUNhVjl1VldJQzdPSzcxYzlXdkRJOXBpUFNaS29BYWhIUURwSDdz?=
 =?utf-8?B?VnU3dW4yQlJNckZtbi9NM1JJYzcxbkhEbVVkcXdTaStCTTFvRGRnNEgvWXNq?=
 =?utf-8?B?ckQvYjBaUkJSalppZWFXN3ZFMzBnZnlqRkFEcW5RSnNRK1RjUTFKNDJ3MU4v?=
 =?utf-8?B?NTlZeHJ1RXBsSFZqNFZHMjBiUS85QXlJWitOTnlRM0NocjVzcEdNREYvTll4?=
 =?utf-8?B?M2dzZytYSGg5WnNWZXdCb1R0RktFeDZ0NEwybmhueWRjdERxOGtpNmluS0tB?=
 =?utf-8?B?bTh1NHZNVDNGSkZNeWV3NUg1TExZTUhxZENPOUtUYUVJYWtnbkE3SmxZTjEr?=
 =?utf-8?B?Z3FYaW5HKzdEa25Dd2xORlJMQWZGRkdlQlJjNGdOcWx6aUpxQkNrWUFCK0dF?=
 =?utf-8?B?MEMxZ0ZDRVY3RzE3SU1WNGRDUWpXWStmbXhPdUFiWHBNTkNSNm9WeE5relZk?=
 =?utf-8?B?KzMyNE1YUEw1dFhWU0N1NGhQK0h0dG0wUVNKS1FRNE9jZVFXYmxvbEk1U29n?=
 =?utf-8?B?aTg3MlhyekljQUtYbnhDRWpMMFEydklqYjZHM0ttcmQxWGtORXI4NWdScEdv?=
 =?utf-8?B?VlVOdisrZkNtaXhhY1pUL0pSaEpkbUM2bSs2dUp3aGwrdERTSUQ1T2ZRM3NV?=
 =?utf-8?B?ZFFOYTRYdVFPU3lxWkFhN3Vtd0dPK3dZamtaS1NPSXNBa1V6TUlHbjJIb1hy?=
 =?utf-8?B?YkJUMVBuSTRUeUZMUUlRdnpWdncxaENvenpQNC9hMjhZWURzSTExVmdDbHJU?=
 =?utf-8?B?RkwwK3B0eE9USEIyQ3liWThLNUk3VUREQ3g2akpndi9TZStXK2xab01HTUFm?=
 =?utf-8?B?MkswNFJmc0Q1N2tYaWFMSGdDQkJ6SjJ5UnBnNlBMRDB6V1dGMm9zZlhlbnA2?=
 =?utf-8?B?MXh1OWtqNWFoNEhvQ0FHMTRkQVBXTDFicHg0b2wyWEZaZk5iL2J3UjMyektq?=
 =?utf-8?B?cURLTFRhRzArbUlGQnh5Z21ZaWJWR2FiL3gwanIwYStKSFB2YWdWcE9jMU9k?=
 =?utf-8?B?eC9icFBxMlQxdmdhODBTZVE1R0tXeWZKNm5Xd3QwVThRWXNPakM2a1hsclJS?=
 =?utf-8?B?bXJuZG9XbksxeTEvbW9uL1k2bDVOdkpESFpxUDM3QUhiZUN2Q1l4d0N3dFhx?=
 =?utf-8?B?dkZGdTdDYndCVlE4NFk0ZmhmRm9Rc1lqTlIxQ0NxTkFaV0NrMTJYQm5iV2ZX?=
 =?utf-8?Q?ZJxkbWxjOuCK2GXFv6mvN7QXz?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ead93ab-8082-4a9f-27fb-08da9b33211e
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 18:08:32.8545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6wERYBrLQrLN1efaCzjabr2tcGZXHUiXxfvtkSUiYlBzJdzGNXVUVJQYv3CBLWnCWsectK5mP3CZxpmw25BaMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB9100
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi fio'ers

I have been working with a few others on NVMe performance in a range
of different environments. At the same time I have been tracking some
of the reports on IOPS per core for NVMe+io_uring [1][2]. I was hoping
to create a standrd and repeatable test for this using a mix of
packer, Ansible and AWS machines.

The idea would be a scriptable flow to obtain a working
fio+libiouring+kernel on some AWS EC2 instance(s) and then automate
some tests to obtain IOPS per CPU core.

To help me get started on this does anyone have any pointers on how
best to configure the system to maximize this metric? Also any fio
scripts for this that people can point me too would be excellent.

If there is interest I would happily work this into a patch for fio
(perhaps in some sort of CI way).

Cheers

Stephen Bates, PhD.

[1]: https://www.phoronix.com/news/7.4M-IOPS-Linux-Per-Core
[2]: https://twitter.com/axboe/status/1452689372395053062?lang=en
