Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97ECC433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 22:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE16A6108B
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 22:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhIHWil (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 18:38:41 -0400
Received: from mail-eopbgr20091.outbound.protection.outlook.com ([40.107.2.91]:36686
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244663AbhIHWih (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 18:38:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVF5/hB0N6uNyfPvvySCcJk7h5Mjgw+GhSKGEscUcQTruMpO8GbJ3Bjh6xMTnJfGTvOzNdQ97hQUU6Mf7e3VbS8QcUfRxuaqiHVVvAApedwHMDbMTx9rIGybNU7/WQ7r2AQGSDiMPXTtxNdcxXf/YSQKBe+1duKmhTooHC62KxEsCiIXNJ+eMMZLMLOQxAs7xypxqQjaL0qs6PXGkSJ/UalVgqLTLBAjwA5Xkb24FF2WqLf7dDBrFjOAzqB0J+1bxWdBI7WFje2XmtFdbWWL/XUd78zy2bu4kVPjgPbA8av7jY4S+gBaBQyFh6m1YiHTcYuWuBkhF5kzePfdwfr3aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PzB0/KGewhe3XQKyedBllXSfcNLUe6uG2MM5OmLBNkU=;
 b=Wplxdu//ebfVD3Aek3aGSyKbWVt7MqmfEO2uSHGRIQYgKwj4B3FGsZtcAb4bX8IpkjQIIIHNpm4vX8Q+CbIUzlV0tbKTJ76gmFHHcYHmDHvXUxpX4RRvLs2s5Uzuvx9w4m7xsX5dCRwexDU5tPxis9q8KayQaWtjDvogXepzHJznifFqI+sP35At3zq90TfCc6InwE2YzInsROo6YLidh1y8M50oeIog0duh0Wo/KcLu5L41eETKam5o8DOp/YeN3EnrCvOQSCQ8PyO3MW6T417ZQjX4aMHBMebahuzp2misURoIM4aTx9hv/UV45IWtFmzp08mLybfDi3srRF/QDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzB0/KGewhe3XQKyedBllXSfcNLUe6uG2MM5OmLBNkU=;
 b=OQE+jVXT06Z6+tSZMptKBZr69tgkgOGULMmi//meJGNjMlWr2BkN2HlX31M2JsJRD/opKo5aaqvuvH4x/K2uZy0ckT/62KdJHf1RvB7z6ZzPlZSr0USKKNAgZNtBNsWLot02Q1mEzChHw16cDc+gokc2wOLE5DZOarZv+f1oTBY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com (2603:10a6:20b:3e0::23)
 by AM9PR04MB8227.eurprd04.prod.outlook.com (2603:10a6:20b:3b4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 22:37:27 +0000
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::8496:1aec:598a:3ed1]) by AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::8496:1aec:598a:3ed1%9]) with mapi id 15.20.4478.027; Wed, 8 Sep 2021
 22:37:27 +0000
Subject: Re: Question: t/io_uring performance
From:   Erwan Velu <e.velu@criteo.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
 <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
 <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
 <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
 <2df22c68-6040-298e-4512-752cd10b7201@kit.edu>
 <5015f1e3-eaeb-ef9e-e530-83c21db5aeb7@criteo.com>
 <e41a49a8-f5ea-9f50-0327-dd2af9487153@criteo.com>
 <08a0ddec-45b3-bdcb-e428-e17ff55c5382@kernel.dk>
 <9b72cfc0-c4e7-3ece-1f66-21b66d45d565@criteo.com>
Message-ID: <8e3e78f6-947f-1566-b666-736c9fb9e353@criteo.com>
Date:   Thu, 9 Sep 2021 00:37:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <9b72cfc0-c4e7-3ece-1f66-21b66d45d565@criteo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR0P264CA0064.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::28) To AM9PR04MB8340.eurprd04.prod.outlook.com
 (2603:10a6:20b:3e0::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:de8:8800:a11a:413a:fe7d:f6a2] (2a01:cb00:de8:8800:a11a:413a:fe7d:f6a2) by PR0P264CA0064.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 22:37:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b4f3455-f525-4f60-e464-08d973193c1b
X-MS-TrafficTypeDiagnostic: AM9PR04MB8227:
X-Microsoft-Antispam-PRVS: <AM9PR04MB82270DFCC3DB484AD5534A3BF2D49@AM9PR04MB8227.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSK9/HvWfVVMGpQEH6uLA/m7+h2WNKXP0vxIPv3t9f4d2nEN5DWJLOuvg/zU1lnSkHD1d6uwkp7rvWk7BdnVgnzbYsUQG/yMq18brxJ20gsVTEXkbt0jqWyOR9vWPfWnGcf9yz8ucIDbCG0XHEIghPQuaSSZlMZjZk+qrgX2vzhuu8SNKD3UsoPGlPQZBblwV1RwPxkM3afPpXaY9mNUqaK0ppm7GQd0p6FCEJC991aWTl9VPa2As5Ryxf18yj+RLRbOxEzHcw8c8J2xE2emS19CB3kAlTwcr03vBUsEkyaug04KDNVotXEZlGUYC/Y1IN+vcEF7pjiTul5oysi38Af9YMEV1wGTEgHhgXwPZ4jsQspm6iGsPk59SG6v3H7CuexU8RAPA4++2yOVICArzfet/eCPGlceGluAFbMNKb3dD7SFCXf3lO9d95sGj9Ud8uCukFoVYteglExOD8s7eEhEZGQDzwqfz6K5+X5J3c1YnKxRcEHsV9YESQrAGqw1nasFlhRFPntjbvnOK/ccWvyKbD0AzMq6fELivnnIH/7c9Dsu1hdEkGn8PA/XRuRKWAP4T9FvKGQY8zgrS+eFO9EnrwQ2plc+TluzIJJYMJWEVTpjDKQhiIJnUU6Ew2UOipuulOnPtGU38JHZhzCkV/O28FTFsmMTMyHrf2jUEwbQ8FUbmwXvJ5SKVm1m3IBHqyzyuAG0La5OTbh10hbz6puqB+bngBatCiHZdOBZ+vw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8340.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(38100700002)(31696002)(6486002)(31686004)(2906002)(478600001)(86362001)(4744005)(8936002)(66476007)(66556008)(66946007)(316002)(8676002)(52116002)(5660300002)(36756003)(2616005)(110136005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkhVNnIzd21jOHRZYlJBaDZEbTN3eTZHaXVGUEJCZ0VqeS9yQ29wNUhFVEsx?=
 =?utf-8?B?UGpZL3hLVjlHaTRWNk1FOVNFSkwrTURCdmRWT0gyaU5lVEk4WHJJZVZrbHgw?=
 =?utf-8?B?MUg0YmMwbVNtSkVHQjVqNlkwZGZaZzYweUI5R1Nvd2dIWE03Mnlhbk9GVTkr?=
 =?utf-8?B?YWwrN1Mya3dDWGxTdFBPMWJpSEFQaGZJb0ZoaVBlbmJYbVdiUlZxbFUrMlVN?=
 =?utf-8?B?WU9VajlMOUdjY0RjNDJmeE0xdXdDWWtGRVlkWW1XeDg2Zzl4MFc0U2dhRlYv?=
 =?utf-8?B?QUtSZUdpTFdOd0ZCdjZOUk9aVmNYUHVRemZ6ZWF3YTdlQkl5eDA4RmZNenRu?=
 =?utf-8?B?eU5pRFFHVGZWUDZoWGJzNFdjWDZTRG9UYkYxSmJ6aGJpZ1BuM0QyQ1ViRy9m?=
 =?utf-8?B?QnJZTFFXSzhaZHlweE1aUWswWG9BZlFJWCtycFhhQ25YZitUUm9ZUUl4ZmtG?=
 =?utf-8?B?Q3UwOERTQkVrY1pZMUJpc1NBUFZKQk1JcUk5Nm5LRkZvOVJWMzBFcWM1a0VE?=
 =?utf-8?B?Tmh1ekdaazI4YWRyVndmTVNmUHA1dEx6S2NFaW9TTmpGMkxTSHhPTjlEeDNq?=
 =?utf-8?B?dmdydCs4dTFvZ1QwVG5WOGFjeG5Hdks3WXdnZnJTSzIvcEVYTnhjQzNuVUJ5?=
 =?utf-8?B?SWJRNDJjMG1Vc1NYTEtITTlDcFE2UTd3MnBhRk1LUko4TGgyY29NS0VXNzVD?=
 =?utf-8?B?b0FjUEppYjdmSjVZd1k2cUpoRmJyWEpqM3lLUVp0ZjRJOC9XWUhrenJjV3ZE?=
 =?utf-8?B?UVhQKzRWS0k1TUVqK3ZxU1A5VjhvRHdJV2tUUm9JWkhmVWRDNDBQMm41ZStv?=
 =?utf-8?B?UGw5OW9kQXYvOUFoRWdReklNbXdUYVMvRFQ1RzJBNVozVFhoWm1aOFJMZWVv?=
 =?utf-8?B?NVdyNnhnQm1xODFCbis0MVJRK0JyTm1YQXZnVkJwaG9jcWd0QTFkREhaczI4?=
 =?utf-8?B?eFA3R1J2RSs4OXZCZEkrZndlYnpNdlZncmVCcnlVenRRZ1NYZE1NQVRVaWRv?=
 =?utf-8?B?UmFVaElCQ1o4UlNuSjl0cXdlZVA3Ky9tdmorS2EyZFd5N25KZmh6K3dFeFJs?=
 =?utf-8?B?SWpjUVZrek1wRFpTYWlDc25JY2UzOHF5L0pjY20xUGtFYkRIREhVdlB0cXUw?=
 =?utf-8?B?UTZXWGJ5RjRua29sS1lobktBVTI4eXIzRTZzUGxpR2wxUnRJV3Y2eXdMZGVT?=
 =?utf-8?B?dVlLUUwyOGE4MHlyYlVWUm9ITDFIU0pJbDZRMTBYQVB0U3dDTmZNK1pJSHdp?=
 =?utf-8?B?RTdsNzBPbE02TmE4cmFJVDZrbUx0UWR5eGxHdGZLUlJjQ0lSY2VmdjJsdWhZ?=
 =?utf-8?B?VklZZFk4T3RQdTVNQmVqcmF0M095TnJDZHBEdGl1SVZ2UkhyeHB5M1lwR3ZF?=
 =?utf-8?B?TVN1NUFBejlaTytrMyt0V3RzSGNVRHVseTVaVTJGeDZjL2czaWlyV2J4bDMz?=
 =?utf-8?B?ZDRXVk80N1B3YUJFVndGN01HOFYxQndaWFVNanhKVGJlMlBvcW90OGpYVFFr?=
 =?utf-8?B?QndGSEd1dlNqWUpycFpvL01VY0Z4WGpZMk1Dck1TSTM3NExoQVdXZkl4aTFO?=
 =?utf-8?B?aUJKMXNUcmRqV3N1VUxtUlVkZFFudjV4aVhPeTFJbmhCWUFHV0krU1FUSWgz?=
 =?utf-8?B?YUdNVFJ5SnpYUFh2OE9WUEwyM0ZIQTFOMnpvd29nTXVsRFJ0U0ZLRXBwam0z?=
 =?utf-8?B?U0JZaG1kREhSL0xFVllCdlJMYS8xQWpQbUlndVRiUlErMW9OSGdMVjNQb0JR?=
 =?utf-8?B?L0RQRElHRHZLWi9lRzI4ajcrUGk1VHlKMnhRQXV2ZlNNMWN2SUxRTk5WakpG?=
 =?utf-8?B?NWMzdzFLcERvc2JuOG5ER29jc0ZZSmRPbGV1U05RVmxBdmJELzFqL3A3WHdG?=
 =?utf-8?Q?IB6mHv8q2xTej?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4f3455-f525-4f60-e464-08d973193c1b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8340.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 22:37:27.0459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qC7nM0mNLO4FdbV6A5VAGVmzs6oph+u9qgoOvTwPs7vPyFlFZbR5UuT59v0jOSEK3/o2BeBKm1OXTp4QK+cSeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8227
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Le 08/09/2021 à 19:11, Erwan Velu a écrit :
> [..]
> Enabling 32 poll queues:
> [...]
>
> 2 devices, 2 thread nostats : taskset -c 0,1 t/io_uring -b512 -d128 
> -c32 -s32 -p1 -F1 -B1 -n2 /dev/nvme2n1 /dev/nvme3n1 : 1.84M


Just realized something here, i'm using 2 devices with 2 cores for a 
good 1.84M, but cores 0 and 1 are not on the same physical core.

But I could also use 2 logical cores but this time located on the same 
physical core.

Thanks to the good Zen2 hyper-threading, this should give me nice numbers.


So I made a try !


2 devices on a single physical core brings me up to 1.23M (that's 67% of 
the previous result on two physical cores)

3 devices on a two physical cores bring me up to 1.85M

4 devices on a two physical cores bring me up to 2.48M

4 devices on a three physical cores bring me up to 3.77M


That's really great numbers ...


