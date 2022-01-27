Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351FCC433EF
	for <fio@archiver.kernel.org>; Thu, 27 Jan 2022 14:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242148AbiA0ODZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Jan 2022 09:03:25 -0500
Received: from mail-vi1eur05on2115.outbound.protection.outlook.com ([40.107.21.115]:17281
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242199AbiA0ODV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Jan 2022 09:03:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hk5bD7xgadSIKkJfZmiVJ45O/b3nJqwzz7NOkdHyYM3oOAUaeXv8dlDiIqbTTu4iwt0GaKzmiRQ7eKyuje03v2Om5c054QdrfVIx9WPGX0i8U71CK1cD2audxileXTuHkAVt7y9NMQwXDBlyP3Gkqu49pZ/xY5lY31wZBWWUD69nH3F8LybUheIFCRL0kG1L+OwowsHHokilP5fbU8J6x17X70CEPnITQkACF4dhyppcQ+pUpt/KZ3gxg7roWqcnneH/LOnZ+hSPVKtwuWc8rOSAHq6GA/xsyfjHEFtvfymTmMjGo5dJKcADoCNfH6bvtUIvNCWwd3PkkngfLq6OWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NikaGzFSdj1wGbZB5R21ymBU6E6UvJJ8iBoBwcc6tow=;
 b=KQpPGQVAmw6PbfbQBKNAl2IPQXdrdXjeIG0uSYHH+pzScl8EDoXg7DVZTAfe8FaFApRRzOJQ+2aBPpQbTTDq/OA74ibjruFN9XXwU2flmjG0D3zYIjdCyFB5ACmTbKkAa8RiqqwZuePzAttp9HYnvTYIZRB4bqiIJFUQo+pv9tBNbad+qxjIi70SOneF7xpfCNUXuFOYUSxmnEf3xenkLySa9yBHC2PvhAedwMuh1GZ5a4PGN1D+m0mov/1ayxjUoWXZR4pQCuS1K2NedB3tTuh3xrKLruNH6SR9aQxAyJdE+5jyi/mgm+2FpKU8K4LEmO+9tsxFmVwZ/DZesuNdMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NikaGzFSdj1wGbZB5R21ymBU6E6UvJJ8iBoBwcc6tow=;
 b=dUifx5WYhsfeIVtleiVW67CFe9omQ8gfqcP5lHZQsOTszm97g3j+ss0qFEg0C8RQSBQfsiMU5qdstXUDZ/ockAllupZMOrboHYk3nB3p9SdeX5xxK2iDGl2Mep679OmvomYMKnHYvgL+IkI9w2UQSfLLCrU703mAjpIT+Ld7DHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=criteo.com;
Received: from PAXPR04MB8989.eurprd04.prod.outlook.com (2603:10a6:102:20c::11)
 by AM6PR04MB6374.eurprd04.prod.outlook.com (2603:10a6:20b:fb::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 14:03:16 +0000
Received: from PAXPR04MB8989.eurprd04.prod.outlook.com
 ([fe80::1055:353e:4b80:afa0]) by PAXPR04MB8989.eurprd04.prod.outlook.com
 ([fe80::1055:353e:4b80:afa0%3]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 14:03:16 +0000
Subject: Re: A fio job that just waits?
To:     Nick Neumann <nick@pcpartpicker.com>, fio@vger.kernel.org
References: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
From:   Erwan Velu <e.velu@criteo.com>
Message-ID: <5f2cbacd-16dc-bc98-3bcb-24a24f160476@criteo.com>
Date:   Thu, 27 Jan 2022 15:03:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR3P189CA0049.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::24) To PAXPR04MB8989.eurprd04.prod.outlook.com
 (2603:10a6:102:20c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b5e3eef-5d62-49d6-04fe-08d9e19dc3db
X-MS-TrafficTypeDiagnostic: AM6PR04MB6374:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB6374D8ED0EC21E1D1D879CBCF2219@AM6PR04MB6374.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tyb+FjYD3ZJ1DLWvdp5mZ5YIkrUoUVg3f4u6iDWmM6CiXcMmNh7KMQDgTAcbE2SddSQdPsvJLv/HdmTHyP4zWGE1/BAlfFjpCEhcqteSypjGTqwmRDahyJfowz4US2H/wQIw19tfBwsqd5UGLKQjSaFHRGePTWbAoDpeWzR0KTqWOQ7crpSfDRSv/m82UgnrxV63bcO1pvCUbjsJIy6ZO0JQpRYSBozhdQ+iuDGkw55gu/snebMRYkXkXRQK5v3J/xteVqbW1denmwtlv9AxaDfEb4VNMslrUAv5e3hPPPktKbgdiWIYMyFYJBjd9iUQzvA5ThqpHsAYVLwnhPlhpnYJ4Cqc69eGOXpgA0IPOgbBlUuf9go1d41onu2zO+TRkPhnRuy/B3AOYSNAZutzRW3aoJwc3W6PFFaYgZ70squYTQbzMCAMNUI3w5PWKjjWmSe6ukPV9m0AYgWbcW9mERz5v3/+ckTQ7t9+EVmOEbmsVYQ9RMvV03BAza4+7QhdS3nVGmDg2djwrPHnY6Acme50i0m04q1d/ZgcD9ximlyWGNMdr14mqSiDSKuJPz2PYbZ4kDhRPfYoAnxk3Gksko9YLmCtEQ0SNnZwyOaEv0ttajP/yesk7o38reKJpx0+iksQpIKSiNC6f1rTTKfef/KMCsMjsKBkUOxPcIg7mmUZL06kzqDUBP8kR+u8JEZoHxMqpaZZXcUX9DZD5f3KAAMICPXZ05dmJRkbcQpoZoP6+ssk1/Ak2DN9zSznpOhZEgr3mmjF1HqL8XYHtjQ2zvIOVQ/AtCHejOExa0+xytaBrOecDSjbIUkgl0/wAIgpR4aF66FKk1vlwYCRLo1Z8bX7aLk/0XrB6tGT0zSukfg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8989.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66574015)(31696002)(316002)(6512007)(966005)(508600001)(83380400001)(6486002)(6506007)(186003)(86362001)(2616005)(8936002)(38100700002)(2906002)(31686004)(5660300002)(66946007)(66476007)(66556008)(8676002)(36756003)(45980500001)(43740500002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU1oZnBSUGI4eEtwMFlCNnpWM0ZwTGVMZERLYnI2KzJYWlY3Tm1XclVRbmM4?=
 =?utf-8?B?VWhHZEJpQWdWc0U3cWhOaDZvd0U3cDFMejFKYTE1OTlzbElvMzJhdnRVdE1R?=
 =?utf-8?B?MmlXaVc1bjN2UTBQdU5FYmxOT0d4dmF1eFAwdyt0cmNYVkQyc1lvbjY4VkUy?=
 =?utf-8?B?YzJCMnpneUF4dWxyOHJ1bHZsWVdQYkR5YmdpVVNiV1lCVk5xNEM3QWtSQVd0?=
 =?utf-8?B?M24ycmpYY1FyVUVHSTd2bWxMdkhubDNscDRYMkFEcHBmdldhV2JIblhyUGlq?=
 =?utf-8?B?VmF3cEN1dkphdVRpancxRng0QVI4R2gxWWppajZhR2V5MUZhdUZFdC9HdVdI?=
 =?utf-8?B?dkMwRXNwZHIzdXVPdHBZQWt6bEE4Qmw2MDJub3pXZ3VnSzRkcy9jK3JEcitV?=
 =?utf-8?B?UTJ1cVFOOHduT3pqMU8yZlhBUUVpSGtydlpSNVRCME9oN2R3aDI5M1pHbFVl?=
 =?utf-8?B?bWpneUJ2d2RUeDBvOUtmejhnRCsvV1dnZWppUEtIRmpEYmtOTDBzY3RYZEU5?=
 =?utf-8?B?d1RVYWFiOXZhMjJ4QnJvMUhxNy9pMmdkOUpIK3M2bmo3UTJ1OWppUGdNOWFJ?=
 =?utf-8?B?Y0pZL205c25tcEZXTjkxL2pvOVlncWZnVEIvSWpYSi9CS1VTd25tR2JaSWdN?=
 =?utf-8?B?bmdFZDdEN3hKNTNzNkNFMGJpQ25mQmtRaGlFTjRvVHc2SzliZUs5dDR3eWlt?=
 =?utf-8?B?UGM1M3NsZCtVa2VpZXNtVFRkVnZVb3A5ZEVuY0g5cUw4Z3NFQkRXM0tOUXBr?=
 =?utf-8?B?U3Fld2ZZNjdJb2JDR2dsVGtiL1RIb0UzNTMvbE81S1N5d1NENklCNmhFTDIv?=
 =?utf-8?B?MHpwT3RHdFhLRTdEakhhVXlOU1IvQ1ZFa2dXV1lIdHZpUnluVzRrK0wyUEVY?=
 =?utf-8?B?MURhc21kUEkwT29BdzdtZGQySWtuYlpla2lPRW1tOTk4WjJ1V01zeXlIM0hq?=
 =?utf-8?B?bFJNM2JJWE15RHoyK1NSM080L1BvK1hJbEFQb0xPeFprQ2pLOWptMVMvdFll?=
 =?utf-8?B?S3k0WTFBTnRTVXpHVGNpZGhxOTR0KzFqSVpwQzk2cmQxY2J3RjZQLzFaL01t?=
 =?utf-8?B?N3QzRTlJNWlab3A2RGN4Q2tLbnppVytWb1J4RlZ5T0JGVTV6c0NtZmlIblZN?=
 =?utf-8?B?ajZKU1BJNHNFZ1NtUUJsTnE4c3NTRU5UOU9yUG1IMGtiVkFlVTR6M2lFcGJw?=
 =?utf-8?B?WlozeHJqKzlJTjg5Tk1qYzFiM0w4RTlQUFduNHdMUDQvNi9BSGpnTEdZejdx?=
 =?utf-8?B?SWdPMCtOOTRHN2RsZ2pDK2pzenZhOUMzWGxYT0ZFdW1TSG5DZEFYbktoRFRD?=
 =?utf-8?B?M0lmUDRoRjJKbmNDUmFzZmJuOFQvNXhnZTdvMkFrWGoyK1dYSDVnS0E5WmVF?=
 =?utf-8?B?UmZpeG9WZUxIYTRhUUE0RDkrdUU2Vld5Q1FwLzdBTDd4VEl2d0hTTmRMSTJ6?=
 =?utf-8?B?UzQ2R3VLRFkrdUcrVHRZN0NJamZUTGljbldPV0o4bWx5VUNGUzZKTFJQNVlw?=
 =?utf-8?B?S1l0SGU2TDJUVlQvWlVBZlhURWNTcUE2RDU5M3lLazB2YmlMRmZ2Q0VKRUs4?=
 =?utf-8?B?ZGRqVHNBaVgrS3plU1RJaUlxdkM4aW9qRURkY3A1QWF5L2N5KytvaWxhWFht?=
 =?utf-8?B?RmFEYUkxYTUxWDQ4OVo4OHoraGhkVkVNbHlPcVZzMW9LL2ptaTdDZnl5dzRB?=
 =?utf-8?B?THZ2cjFVWXVVTG1IKzJFbEM4eWlNTWRKaVBqZUVWeGc0YU5kcE5HeCtPUldY?=
 =?utf-8?B?dk85VHdEemt3QUZ4Y3JTOXBKK0MwU3pGbG5heDErZldIY0RsdVNDT1dlTGlV?=
 =?utf-8?B?bnU1QzdmQmRieDdRd2srbHc4ZU1KcEJPMzZ3SE5XMXVhdWZsM3BBNTFyTUEx?=
 =?utf-8?B?V2REcGhBK0xNSjRZcXlrK3ZaeW9VU1dhcjhvYjBiakJuaGJmQ01oaWRPVktJ?=
 =?utf-8?B?VFFOSndqL0RJelc4bWxTTWNqVytHOEw0V3JlYXZIVXlneGhMYzVZM2pFZG5s?=
 =?utf-8?B?dWZwZC9scGtiRktIOHJDcUhha0lnRlR2UWdVemdiczR6RHMvNmt6OGhBRUhL?=
 =?utf-8?B?Mk90MmswMHBycUlMQTNaenM5c1RyM0lUUTlzRm80cHd0d3NvMnBWVFdsR1U3?=
 =?utf-8?B?SnpBZk8zY1BQc1djU3J1WEI5S2hKVHZlYWJpSHNCTmZZc1pLR2ZaSlNxRXo2?=
 =?utf-8?B?QWU3Y1dUaHd6NTNlYnhrNnVJQ1VjUmZqMVhiVHI0L3JVMk5vU0tldi9saGVY?=
 =?utf-8?Q?kxRe4klonKwtrZlXcxUXBvVKDWxdvxBkkx+UGxhePc=3D?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5e3eef-5d62-49d6-04fe-08d9e19dc3db
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8989.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 14:03:16.6035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRp2UGWTSY6Il16ltM1sHul7iOHZjE1HmweX4PCcCCZ7muIX7fja0mO6KKGStAoYmI+ZShNVTJ36QmgzSqj0jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6374
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Le 27/01/2022 à 00:08, Nick Neumann a écrit :
> Is there a clean way to create a fio job that just waits for a fixed
> time period? I'm fairly new to fio, and want a delay between two
> consecutive jobs. I use "wait_for" to serialize as needed, and
> expected "startdelay" to allow me to put the desired delay between the
> two. But it looks like the startdelay for a job begins when fio starts
> and not when the job referenced in a "wait_for" finishes.
>
> I can play games with a job with a very low bandwidth limit (e.g.
> 1B/s) and "runtime" and "time_based", but it feels hacky.
>
> Am I thinking about how to get a delay between two jobs wrong? Is
> there a better way? I realize I could just run fio multiple times with
> command line delays between the runs, but I'd like the results of the
> runs to share the same time basis and output/log files.

Nick,

I've been adding an exec engine in fio that could be used to do any kind 
of behavior.

There is an example where I wanted to perform explicit sleeps between 
jobs to cool down the server : 
https://github.com/axboe/fio/blob/master/examples/exec.fio

You may try something like that 
https://github.com/axboe/fio/tree/master/tools/fiograph can help you 
graphing how jobs are interlaced.

If you look at 
https://github.com/axboe/fio/blob/master/examples/exec.png, it gives a 
visual representation of the sleep action in this example.


That may help you,

Erwan,

