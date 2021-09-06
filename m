Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6F6C433FE
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 14:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA1860C3E
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 14:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbhIFOmd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 6 Sep 2021 10:42:33 -0400
Received: from mail-eopbgr60120.outbound.protection.outlook.com ([40.107.6.120]:24197
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238717AbhIFOmd (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Sep 2021 10:42:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrE04QHiWnzWZk4xaN4bSkvu5eTYxRPIRBV4mCStWNlA6WHKsqlGGYgZuWEMZjV4pe9yIarv5LnfiIwRd16+LWguM3a4hwVotHjDKJwHRItaf3TP/sCScPhEFSJeWSMgcNhcnD9DKYi2H2BQSPoFC6uOpYNwKBEPAVeqY5nJfNxqOlbrEcC3d22l7BO8InXd6zupvkMq22vWlxiKe6S7PyM2Nbhrw21/1Fw4KdnVt0r7R+MrLpzZ44H/sRszDzf1MWoyyWCn91nM6hhojppXl1F61qx1EmmVwNSqdfuuvDZ8r5wLHCxiT6wBm4bvXUaGpxL9EJh9Rx/oSLVa8mKu9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HQBH2sezVFTz1n4pgSNJ8lWEHZ2pTgvHHZ4C5pmab94=;
 b=YrpjnPP5SbFX4mM5Exn+q2kc7yrfGDslzRaWwMvvck211Xf9gq4N7UlcsNRI8NBcRgi6JO+OsGJKoj/ytOzuh47TyoGf6RuBybrNAnzz++/7pfv+FIVsNwlLfyM81EjPOWEZ28g2Cgoad0iYp0HofXL2h/8fJvigVGqL6J/8+hryl2IPzGC6ZI3TIto4CAxmlj+JnsrfoK8fyibCnSC5JM+BdQKjLkEJvoX3el2TPDyMbS2lmyxMYoT/Vh5pVyGgTT3g+r0fYkr1R0bwGpviNOkpHGbvalL9yzZ+LGdv6vTj8gFWrAnuj4UgltNh5UvsrFdFM3+CZtEHvgrzAe7lQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQBH2sezVFTz1n4pgSNJ8lWEHZ2pTgvHHZ4C5pmab94=;
 b=QmDg/Yr4MVt8ycLfwZ+BBUNJKSy3qUJk5URybTXk92OjCmawZgfKSYcfECgD6W7gZDMP1B8+uoyQq5/qSanVx8/wMADhs6iZZ3zuJ+4pG812FlkXyusW2LoB51piRSwcP47csyUt8ukeYHFa+5ZUFW5LGnBKlfYgmtEvjZ8LINY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com (2603:10a6:20b:3e0::23)
 by AM8PR04MB7459.eurprd04.prod.outlook.com (2603:10a6:20b:1dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Mon, 6 Sep
 2021 14:41:26 +0000
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::8496:1aec:598a:3ed1]) by AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::8496:1aec:598a:3ed1%9]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 14:41:26 +0000
Subject: Re: Question: t/io_uring performance
To:     Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>,
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
 <77b67cc0-30c1-70a8-438b-f1bcf1fdb295@kit.edu>
From:   Erwan Velu <e.velu@criteo.com>
Message-ID: <913de849-057b-cabd-49fb-1123f3d58eb6@criteo.com>
Date:   Mon, 6 Sep 2021 16:41:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <77b67cc0-30c1-70a8-438b-f1bcf1fdb295@kit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: MR1P264CA0141.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::15) To AM9PR04MB8340.eurprd04.prod.outlook.com
 (2603:10a6:20b:3e0::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:de8:8800:330c:619:b432:29e4] (2a01:cb00:de8:8800:330c:619:b432:29e4) by MR1P264CA0141.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:51::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24 via Frontend Transport; Mon, 6 Sep 2021 14:41:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b9be87c-6293-4fd0-6531-08d9714467f7
X-MS-TrafficTypeDiagnostic: AM8PR04MB7459:
X-Microsoft-Antispam-PRVS: <AM8PR04MB74596C18E00AE2AFA270E5E5F2D29@AM8PR04MB7459.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqjhEl9L5E8WlbTYNzOLpgQOV2CxPPG0c+xTjVWGCrZcr4NrV+eUehQc2RjD+hfbByHkyPJDbBONzomnBIO/OuDCjzehnHBCKKRTFF95YT760SgvPZUyXzDXKJtoVG3vh4Ce+AG5lB4KrJUnLowyZfZwanxU2uO/ywU4IBE1IwwHANwHvPJgp+B4GfJQMflo23NjJCNXNTIEBxSKDcHyqyyNcztf5MGYaRCTDm1oXStrBMpp0OPIQtVHMOvpaf9Z1AJl+k8vaaVrd4biIS1M3DY1OFOHzfCtJ+324JOrKnATbCozpWwrIQwgGXYO+gKgx63O+GjDkLIPkEnPFDf8LHn2Mcs7h8zO0Rf1ZwQlpyLGSIgAtEpfgUpTKtvHBbsc0wH+DHh5mY4kGtKcJILBqxim1GlH5stIGdOV+xWgfxDaxhvgbUTzDKa/wIhhCUmte/ndlE0kFLzrLZv6kp/TBZpqfKUCX6/GG+xskXWw9+Rl43h+osZWMwa9zfELz4K/N+DtwK4lGh9AuygflXh7fpte4zxQ1lAMS0vf+6WFn6EId+POih/ATh+aR2eL6PDbCZ1SgkRGRZ44TVPVCvrjtC/NTBAmvaog/VI9HGP1WWk8kIq38dAvtoEt/jIqJEA9wQ/TecpaRD/dpdp3Lzn1iNp3t1WkF6sEkCaOjLXbwrBEoxxQGFE6GF9K7cR7eum0D6Tl6UEByGnR3mgqRAgk+qE1f+zf0UJesf3C2QLlTjY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8340.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(31696002)(4744005)(66574015)(478600001)(6486002)(66476007)(186003)(36756003)(52116002)(86362001)(2906002)(2616005)(31686004)(110136005)(8676002)(38100700002)(8936002)(66556008)(5660300002)(316002)(66946007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUloK2J3ZGNCdGpqOXhVRVVNN1FKdW5SZFRvTHR6eG5OcHNrOHhhZGpzdU81?=
 =?utf-8?B?bEJCUVl0QmkzNnpXckt6WHQyZ1ltakpUOUk0VGRQa1lzNDg0UE1vdEdFTHZW?=
 =?utf-8?B?U21wcndBQVJqOW1kUk5JTkNXREFRRGpyd3NiVy94SEhZV0FsRUdZQ2N4Slpp?=
 =?utf-8?B?cTFySkxaTGlCeThXQm81OGJ1N3doN1lVUTNOZU11MDMrVkxNcjJyb0t1Nkg4?=
 =?utf-8?B?Ym1LWXdIZUZUbXVlcERFbTc3WHN1Tmc3M2hBUGNpYlVOQlp2UlMvSkJyREVa?=
 =?utf-8?B?RytwWlpRQXdOYm1TZFpQQmRONjlKa3dUc0RGc1hBMFltb1FvYnFIMGUyRnhl?=
 =?utf-8?B?ei9lUGNVV3g0NklvUkZoUUFuUEpnSzR6TDNjSHQwNE1IMTEwbFhuOGRyT25U?=
 =?utf-8?B?R1lsSlUyelhRTVR2ZDRCMm1pWHFyeS90UkpFMHkvTjgxNktqZ2NXOUlpdFkz?=
 =?utf-8?B?T3RoVXViQjdvUlBJdy8vTFk5MitsYVVieUI0RWsrSDduUWE1YkpKbHJSMFNP?=
 =?utf-8?B?SW5qaWp1djYrTE9BcTdRM2ErbGcrbTNoa21Td2oyYXhJbjg0V3NOb3JRc3NR?=
 =?utf-8?B?RjhvVFFyRDQwZVdES0VORFYyNXZlcDZYU2ZnRzZPQ3VvaDRMYXBFRVp0eDFK?=
 =?utf-8?B?aE5qbjJuV24yOVNMd1E2SWtrbldSYWdyMnlPaUlaKzI0UmJMazdXbXh2dUpC?=
 =?utf-8?B?N1RkRFVUTlBOSXN2d2lXdFNuVFI0QjlDanpHLzUvOGVTZGYzNUlKTG1SL09t?=
 =?utf-8?B?cm1LbGd6bFo3bEtzVFBCdWdHWG5lZUl0YmxtRCtOczJYRFhsaytvRnhnd3E1?=
 =?utf-8?B?SGkwRE43VFpLRTBmWStURzlQQzlPaVA0VWcrZGNtVXUrckJReFB6QjZuelJD?=
 =?utf-8?B?UFo3R25kcWZvNzhzaHNWV3dQTTZ5VlFFaUNhSjJ2bTZrRzZZeVEvZ1ZidG1T?=
 =?utf-8?B?UEVGOHkvSjNqOGZiWm1tS0hHVHc5N3JIdDJQbXQ0MXlKdUhCcGtrZW90NldB?=
 =?utf-8?B?ZjBLeFZTV21LbGhoZ2xRdU5pUzFRS0VHR0lMcFFlZnlUc3cyclgxcmFMaDk4?=
 =?utf-8?B?a2FkaGg2ekNUbnFpV3hWSkYzK2JvN1ZZMVNCblhLTk16RTh2WHVuTERBVjlH?=
 =?utf-8?B?akZVUjU3UW8xVVNMOFltaDBBNDZQN01pRkk3MUpaSEVyWDlXSWhibk5SV3Jw?=
 =?utf-8?B?d1o1dXUzYy8rMUtzem94YVluellGV1NjY2ppOXpQYjlYZGtYczQvTUZTQ3ND?=
 =?utf-8?B?eWRhU2hCV0FvczZSZkg2alQrZlp6Rm5FTUx2Z0JWNC9aOGhwMHhRcVEvbTFR?=
 =?utf-8?B?U1M5ekVwbVhtTXBoemNpZkFxVkxZS1NIUHlVTjVmTEhXc1dWODNKOTNVSGNU?=
 =?utf-8?B?MUk3Wk9zc2hXcW1lY0NQcVJ5L2tXMFlsVVYxNUxRMGVWNlF4Wlc3eWc5VWMw?=
 =?utf-8?B?Qm9RODE1bWpxbS9jdnVhZkVKZ3hjb25zZU44eElDUm1XTG9lT3hjVlU0czMx?=
 =?utf-8?B?NkdrdmgvclZkYmtWS1lPbjhZNUNzUVloNVVYUGplYmdGQXZkbU9EbHVsUzVK?=
 =?utf-8?B?cFFRNVhNUzZ4Q2pmM3pVcFN1eloyOGtrM3k3Rll3Y2ZYMUxXZzBEOE5odm1L?=
 =?utf-8?B?b3N5eE82QjFTUHdFcGZlMm9aRXFncncrNHJaMHFST2QxN0Z1dk14ZDVBeGsx?=
 =?utf-8?B?aUFNYTkvR08yRXhvZEZQczBlUGFIaWlZVytBWGpIb0M0cCtwcjJ3d2FFQmJO?=
 =?utf-8?B?Y0RQWGdjV1FXVkdqN0NTMG5VNWlHR2p1bWpkNEhlMVBScjNBcDEvS2tpS05t?=
 =?utf-8?B?WDdZdmtNSGdDOHZVUGpZWUxpYmZmNVlVODVwZ1BxK0ptYlRGTW1hZndXWHJT?=
 =?utf-8?Q?qQaotxVoEm/J+?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9be87c-6293-4fd0-6531-08d9714467f7
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8340.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 14:41:26.7469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmQN9AuHX4oRqInVrN98WDUyGypOys1cm8M+qav9FBF3DVSih1qvME+1ADqAUnqQ3omF6zmEw51z8Pdmo12YAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7459
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Le 06/09/2021 à 16:26, Hans-Peter Lehmann a écrit :
> Hi Jens,
>
> not sure if you have read the emails in this thread - now trying to 
> address you directly. Both Erwan and me are unable to reproduce your 
> single-threaded IOPS measurements - we don't even get close to your 
> numbers. The bottle-neck seems to be the CPU, not the SSDs. Did you 
> use some special configuration for your benchmarks?
>
> Best regards
> Hans-Peter
>
> (I have also reproduced the behavior with an Intel processor now - the 
> single-threaded throughput is also capped at around 580k IOPS, even 
> though the SSDs can handle more than that when using multiple threads)


I wonder if that's not linked to the optane 2 setup.

