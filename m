Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8734C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Sep 2021 11:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 963C060041
	for <fio@archiver.kernel.org>; Fri, 10 Sep 2021 11:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhIJLrM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Sep 2021 07:47:12 -0400
Received: from mail-vi1eur05on2129.outbound.protection.outlook.com ([40.107.21.129]:28032
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232613AbhIJLrL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Sep 2021 07:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R02ZPYZ9zEr8bEzYr3WEIUt/9LJs8eNSXuYYsuW7BDtJsdWoW6AgbRYhSv0mdMO2W7CWBYpd6cCcBBn78yjg70BewbmFNJhwJaU43+AtJg/sbvsbPztPBjvUiuTr+EKgVIZ3IT84VzadxyC4dhTJdELEkGvxR5gAHKOtPVEUGSQClsZba76aZPq0N+z/UVAfY+Rd0Ak6qspBes6/r96b/obEGB4b/dnEOFMOPmZsQtLibdGcSHxP4hVizY6cgBfrf7/Y5UkkmJC1bjJivUbomjswPnYE3L6PpNHG3n2VsTuhyjjMUxWu2zGNZog7lAUC4IOmpp80UC2XdifrwTfUvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qC0RXqHAizV64OFqz4CkLQ5waMq2MPK6glsbs0/sdZ8=;
 b=P3xcZ+BOXeN1BOOtb+jyh3UNuRDRCfYuhU/r2vIgQ5s3LIC8lmiyWUfNnqbSoEIRfcH0KKRjc/4L1F5HAw5YbhQmCjJckNY6jvURXUwqpUafG6DoTIsK4tJSRadZwuXTASnTGo8fWq/X/a06CUNh+azngTEQipxd27qWoQ4YxdorOYEtyozC/Tu+cRxW3hETQMQjraTDo0J+/JIezW0Dm0+DLQzB4FWuGfI8M21mU/HW6mKeSGiIqILj6YfaURHGf+lt3iQ+ZLWSzydamR6MneRyz8F7QN0JM73G3u8VfohSDwAfAvxyOeqSGsTGIyvFHdwSyDu6LJGQpc729kfwcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qC0RXqHAizV64OFqz4CkLQ5waMq2MPK6glsbs0/sdZ8=;
 b=lyfTeCfy/Poqa89qgk+7iug21XScIvt8VMkHRAm/rQr+vH2kN8ZDHQ+TkLFzgeRanjtaKzE+7s2xbo/U3cgQy2aFxRk9i35rC7ZNcei36kWyYYJD6nF1+gVOV0vuseYJlu3VWpCRaymRJOenhxn70zC8K6dhAIPadxdSPcTY8rk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com (2603:10a6:20b:3e0::23)
 by AM0PR0402MB3313.eurprd04.prod.outlook.com (2603:10a6:208:1c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 11:45:59 +0000
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::8496:1aec:598a:3ed1]) by AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::8496:1aec:598a:3ed1%8]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 11:45:59 +0000
Subject: Re: Question: t/io_uring performance
To:     Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>, axboe@kernel.dk,
        fio@vger.kernel.org
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
 <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
 <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
 <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
 <2df22c68-6040-298e-4512-752cd10b7201@kit.edu>
 <5015f1e3-eaeb-ef9e-e530-83c21db5aeb7@criteo.com>
 <e41a49a8-f5ea-9f50-0327-dd2af9487153@criteo.com>
 <77b67cc0-30c1-70a8-438b-f1bcf1fdb295@kit.edu>
 <CALjAwxgM65_vfrBkvGksoyO6vgR1dx4aPtGJSqRhm-gieHKgyA@mail.gmail.com>
 <bfddf649-aaf4-b01f-f26b-513fb4e236b2@kernel.dk>
 <8d6acc34-5078-c023-fcc8-cb34b63e5112@kernel.dk>
 <1cf066bb-aa71-1403-c80c-454ea87a9502@kit.edu>
 <4ce4addd-a7c7-f35f-ef3b-b0bf9966e224@kernel.dk>
 <47a5597f-4b7a-fcfc-b57d-2b46c86c0817@kit.edu>
 <5668f23f-49b3-1c37-1029-dabe996f7bd0@kernel.dk>
 <812cac88-dd29-852f-2370-4121376ac64e@kit.edu>
From:   Erwan Velu <e.velu@criteo.com>
Message-ID: <85cdd7d0-aeb1-f726-7bd6-006f2b81fee9@criteo.com>
Date:   Fri, 10 Sep 2021 13:45:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <812cac88-dd29-852f-2370-4121376ac64e@kit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR3P193CA0004.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::9) To AM9PR04MB8340.eurprd04.prod.outlook.com
 (2603:10a6:20b:3e0::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:de8:8800:60d9:3723:4a46:c8d0] (2a01:cb00:de8:8800:60d9:3723:4a46:c8d0) by PR3P193CA0004.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:50::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 11:45:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01e885b2-6798-4e99-e94d-08d974508e9d
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3313:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3313D83363AB01651C7B9DA2F2D69@AM0PR0402MB3313.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ME+Ms50rfuhfZjXINcRDYXFxgeN2n4bz4VqN0uJKUD1SAii+SFNL/unUPLmc9ucZOQ+L/048lJ19sVMydQC4ximERtaaF+FNNkHe73mL7Jl3lHt+9NQP8V8infZcJJIDS0JfahpaDR1ipusV/VQyIuOQv1rjIPAwfzJb+RCETE9nP3WgKTX2ABPrfpRPlk02Memp4Xfmqi1Q2uI8Wq5qYY6fY/OLRK0TKHLwhAMzo0BYn680gc7t3JNxGQHeSS5886JHqOo/2S+YzSdJMDZUe7bQXTllOmp0VqAH8JvBOPJAhJCuikEp727tDKV4R+WcJ8fnkgR3H3vHYZv/gHkdRUHJOAstNEEhzbLyqrtwXOo0Mm+29n+lNIOPg3h4BkmwaPDBlPTuvf7jIGAG2dKbCXjt9NBH9CwnH87/xiLFWJveXS8J9pa1KFDY6u+ickQGHGA0WxV4WnBYpxlwixwIVI3b92a8jw6dvkYOKFMZO2I9k4Z/wmK115NQDBIny3yf9iqRGiwoGX7za6pAOpx2iCnmcr4OfezID2KNsYDrQxRy7+3JpbPWIf0LvZ6fdvTa98mXullIuGWkbC7OhAvDBAZCQXlcuYQhwsSatOYyk/NxGB6cm38rpC26g3wOh/GHDEpZE2G35zEAfiZwZJoCX7FRBXflfc5xs7Vk+zWciGoYNCtZvsujGOvMAcrMQdMEe1sEoxRn0MmihwX+J0WDIay6Iiony3SBgSUKNlrYdyHxkTc7vV0f1CXhtljM4PHmNQIK6nZlX67W7kqEteiHxrHlWr9pUfd+2juI2jX7JunnaaItkYVeNLLLCsRC4C7B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8340.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(52116002)(36756003)(2616005)(6486002)(66476007)(8676002)(31686004)(4744005)(966005)(8936002)(86362001)(66556008)(478600001)(2906002)(316002)(66946007)(38100700002)(5660300002)(31696002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGxpNGI0S1F0alEzdWcydG5JRUQzRzd1L250RG1oMFRHdGt2RVlnWTA2ckVZ?=
 =?utf-8?B?alEwbHZvVDJkeW9MQ0lPaEQraytsdnhwd2J5cExEc0VFNnJxdUJKNUltRlRH?=
 =?utf-8?B?VVk1b2xXUzJ4L1ZHZzZ4ZVJJWW9uN1VmZkVqT3J6YkpyeHkxQXlKVlQzZGhn?=
 =?utf-8?B?bS9MTTJBRkRBdzFRYURzWXJjOVdGdXJaVGVLR3lzNklSYlUwNWt0STZ3TFFj?=
 =?utf-8?B?aUVBWlYxOG5vY2hXRVpVc29EalVJcGpzbC9Mc2V0di9HYzBOVk5admRRc3la?=
 =?utf-8?B?Z2xWVUFwUU83bTBMbCtFdGFWb09jbWRYNkNqdmJPNFk0UGgxczF0dTQ3TVg4?=
 =?utf-8?B?MzRrbERJeWUzZHRaTUdCTW5pS2o5ZU53K3d1ZFBoWHlpRDczNk5GQ3RtblE0?=
 =?utf-8?B?N2RoMEIvcWN2VlRJZnJ3eU1zUmRHVFIrZ01ad20weGFPK25MNXJFTi9Ybjll?=
 =?utf-8?B?SElqbDh0YlYvM1R3bWdqTUVLR21YSEdHWWJtNFF4MkRBUDM0V1pQcFR1WTZD?=
 =?utf-8?B?Zk5jaEh5cUJ4OFozYWEyQmoxUHBvYUpuYldCcVNpajF5V3c0eG14WXFRckhI?=
 =?utf-8?B?Zm4rMUhRVXVOeTBrUGM0aU1KcHFqYUtTeDZrMmhNanJEUUVsOGZOTld1dVNU?=
 =?utf-8?B?b3RIVU9zeDNOeG02aUNOaC9iWG0zK1I2R2xkREFWdmFmdWthNk1xK1E3dU9L?=
 =?utf-8?B?bi84N0hvRnZjUVlmQVlpQTRFWDJiNW9CeUFkQUxkelZBRXcrcklrWmZ3Wnk1?=
 =?utf-8?B?TndDdlZPSkt1VTd3OW9pVDFvVUU2OWluOW91eEF5NkIrVi93YXZqdmlxN0VD?=
 =?utf-8?B?WklSckx0Rkg1d0xqZHpwaGdBOGU4aFJCUmpiellsV0lsSGVlTDc5anQ2SlBw?=
 =?utf-8?B?Q0RFYTVuc2tDQkMxMWlVME1CWWhWYW9pV2FjMWU1WTh3UVo5anFGK0JMalRt?=
 =?utf-8?B?clV0VGJXK1pzZlpLSUZrUm0weHFBRHQ4YWR6VzR6ekZ1UG5NRWVkQmtYY2xW?=
 =?utf-8?B?SHFYaUtwSlh2RVJVTXZrZERHOTRaSWxhTWZ1TGJPTGZkMDNrT3lUaEdTbGNn?=
 =?utf-8?B?akJIL1JhUU5UQk1YUHBTaGtHTGVxcFRpUmpnOFVUNTl2SDAxY2pPL2J6NGY1?=
 =?utf-8?B?akJKbDErb28zTmhiKytYRFd1c1o2MUVnTkNwWnVpYms4R3hQOHpMSm9QYklv?=
 =?utf-8?B?QkZzaE1mNW16eW5vM1JOTXd3RG5UQWNOMHgxeUhzcTJ6ay90WldvbjY4cU1v?=
 =?utf-8?B?eDUvbTAwUDhhaXZlbk5CYXBUb2pSc2lKaTdZTDlKcUJmc3RmRWJ3UStFaFVo?=
 =?utf-8?B?WGhLQXNMRE9sOFhMejNCMy9SZVhJaXYxOEhRZFdGalJHYnU2MTArTmFBQjB5?=
 =?utf-8?B?ZjhCNW1VM3grTC9UM3ZQS01Xb08vNDRVNW9TY2ZmN0MyL2s2cXRuaHhnVHUv?=
 =?utf-8?B?UWtXK2g4QkZwOFlsZThaaXZpYm9JY2FScUtmV1FFMnp5eXRDQWRGc2RDS2kw?=
 =?utf-8?B?TTJLc3FrSHNLSTRuWkhmNlEyVDdiWVFzTGpSZkdZUStSTVhzT0wwd0J0N3Z1?=
 =?utf-8?B?dXVxNDV5MkhUK081OFk4b0EvNElFUE9weGdQcmk1Rzd3aDVCRUJxaVdnWm1N?=
 =?utf-8?B?Wm8xQ0VJZ1dsbm11VzE3eGd3R3NPdE95SFVoOHFkVURwRkhPaE41SW03dlRB?=
 =?utf-8?B?WGpPTkpOV0pyOENqeURVSXIzWERMd2w4LzNVcDlvLzVnYXpXcFdvcUpUWHpr?=
 =?utf-8?B?WHhEcnpqeVBWQW96TW5zSTJQMmVNMk55L3VnY0wwRmxQZk1TKzFZWXVmb3lF?=
 =?utf-8?B?RVJYaVI0eS92ZnFocW8wbzFzWGdpVFU5Rk91WGFORlJGRCs4TEdqcmZDTVpU?=
 =?utf-8?Q?1k47zIja0fZwp?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e885b2-6798-4e99-e94d-08d974508e9d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8340.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 11:45:58.9899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIctac9OfmQlAkLher0Uux9zxfO23DYgzal+5f10O3evPdCIxo6Fc53Tw8o4u1cIjKBQM0q9n0UKKGrOHO25aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3313
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Le 10/09/2021 à 13:25, Hans-Peter Lehmann a écrit :
>> it's definitely more expensive to drive two drives vs one for these 
>> kinds of tests. [...] it does show extra overhead for polling 2 
>> drives vs just one.
>
> Oh, right. Sorry. Thanks a lot for the interesting measurements. Also, 
> I somehow missed that you already are at 3.5M IOPS. Crazy.
>
Spoiler, it went up to 6M/core with 3 Optane ...

https://twitter.com/axboe/status/1435741761897254916

