Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE1CC433EF
	for <fio@archiver.kernel.org>; Thu, 16 Sep 2021 21:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBCCF60FC0
	for <fio@archiver.kernel.org>; Thu, 16 Sep 2021 21:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhIPVTp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 16 Sep 2021 17:19:45 -0400
Received: from mail-eopbgr80109.outbound.protection.outlook.com ([40.107.8.109]:20944
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234312AbhIPVTp (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Sep 2021 17:19:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXIlYOB0+lPAZKisWwy8Pl/slIJZ11tBGEwRJgJHR903eZsLRkiPy1FC+zoqD/T86Sdwb94XYfGrr4v02szMSxMiIZtKiGvazy2RV9FuNmiy3ZJs9/ECfl0AOOPw0AjvOja6/FgVGbB71FkKSk47vFnCcmb+RmgiYP4GrtsDYG+So77qa2l1gSlJx7dlj8LnbGwi/y99i1VZMvcwh/lbES2G65dbCADU4vAD0fk7HDI/zCTXs2FGVrRiwqFRcoSRmX+MJlVW2q/RZMkhYFOE9ISlbKQQ3VXaapofblmYXf/XjkJVkEpQVuDAQ/P4Y23wHj7vQW5NZuVQCyQ1VSTwnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QA7harMcvXDN6XaJnFKOPlXlQFzhmNUa5bexekRX45s=;
 b=cZ5EDjIv1oSV1NqiiLbZt8U/+l2MYGSjfltJ/mcV4J/IiahaPBLjJNNLmrQlJCabavDgj0R1pnC99RNH/YbjNq5mbjQZNQCCn5lC/XwgyCe4e3wCg9k4j0COdmKxteJebv5gFtZzPqgQ2Jm9wT2mmo+p37H6yZy0sUQzouz4FKZUiaruErZAHtDl8bzEVWlDqw8giZKmZtrUj247tQ03x0Wv/jQwtd38iR0MRQgHBpoaVs0sU3Dw6vSYndv8yhTpZSxd0adHoo5qo6uYDOnisO0IGehBt3RlfKojdU+gfMSurYN7sEV7NFhTmJOgrhWaDdheFiILBv8hKEeQbtV7Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QA7harMcvXDN6XaJnFKOPlXlQFzhmNUa5bexekRX45s=;
 b=aOpRNHf+OhILUu4uALhNwSw+AaA6/Ka9TvmKVhuwL+RMer5o2yiRkyAhEEwHkwfuCUpHt2MmlOCD1d14LZm4hUrz5qdjV5eo2njz0tRXbWv60uhqVmBT6U/ivoTyB+Zafrbnpxlfed9y9GuBrxtppkWjNuS6N3gUtGcg4E3sivY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com (2603:10a6:20b:3e0::23)
 by AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 21:18:22 +0000
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::6468:321a:74dd:5b62]) by AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::6468:321a:74dd:5b62%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 21:18:22 +0000
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
 <8e3e78f6-947f-1566-b666-736c9fb9e353@criteo.com>
Message-ID: <796c8f29-323a-6fbc-09fc-5c739c81a221@criteo.com>
Date:   Thu, 16 Sep 2021 23:18:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <8e3e78f6-947f-1566-b666-736c9fb9e353@criteo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: PR3PR09CA0004.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::9) To AM9PR04MB8340.eurprd04.prod.outlook.com
 (2603:10a6:20b:3e0::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.201] (86.242.91.196) by PR3PR09CA0004.eurprd09.prod.outlook.com (2603:10a6:102:b7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Thu, 16 Sep 2021 21:18:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31e8707d-3d59-4cfd-2c87-08d979578351
X-MS-TrafficTypeDiagnostic: AM0PR04MB6529:
X-Microsoft-Antispam-PRVS: <AM0PR04MB65299C23A88F6F6EEA3F9EA0F2DC9@AM0PR04MB6529.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5K5BqEikjYw822TV2E7IURHR6rHtw6RAeGvWJmnCEKd6WF/a06NigpIXOta8wXkSggJST46Rj1EEYBIzVULIUmwGThowxDx1ZcvlPhDydrOJsXXemlUFelaxUNjpNtfEqLDHOGEliGeh9M5X5flI91GpnI/8F6+JvUdnRBqpWNnFZGLaqd3hnMLucMs8LPImq3Eurk1r2bDTNfFlXBef6du66tfmmMmtmyr/2d/bRWzlU5kVdYb9CulsSirVO0qbbIuEoorWKkKP3k116QPQOBb4jH7pXURrC9yUu1csKJ1y87mdTCgl0OlS2y7E8p4wzjHBpa8IlVFX5+oG6R+Q4viZ1EDXpyHXX6lPqpGAdN3iS92xNGMVuz8jOPEVu1+Tgusl8lVobnyu0gP3O70R43l1ibMwt5a+4fgqqYAzXsMZxeKCu8IOEF68h+lbwOycJFee1d9E45/0zI9pXmlktEfSOJ3mS2pGUIXVL6uKufbuVxPMdHzcQTdIOBkyppJQHNZ7mS+n0TL4+hb6W10nKIugjuWIou8iG7rg43q7SLwu4muUHLns9QSwnrXFXZYGyz/AnDGHUSDfFTmGqZyrR5/nPi3bCGNzVLGUe006nuJM4NPDVDMPyvH7vDuBg9mcSzgOcQt2pFDDn2bBHjNygrOR3TZ72+8HvCH4QVFDDcUvlXtp2IbmUbZuSpZggcU69Vz7luen78xTSi+xaqvP3L0ZvusUruGx1qzteRwdlwCNvYvf3HDutTzAIefe1Ws0NUd4fzIMwb18dSkUJ+MjwvOfFA6NuGV1CD+TrHUUT6B4f6Q32wQODaFuasTAuE5aeqDsqFS+RkJ4HSEfjvikp9MZDZOZYMfH3KO1qdu6Ed0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8340.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(8936002)(8676002)(38350700002)(26005)(4744005)(38100700002)(66556008)(2906002)(31686004)(2616005)(31696002)(86362001)(956004)(6486002)(478600001)(36756003)(66946007)(186003)(110136005)(16576012)(52116002)(53546011)(6666004)(966005)(316002)(66476007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Unp5VmpENlVjeSt3SWt2UXRWMTJMTk9rWlllNGovaldjSXNCNDFJL25CK3Ro?=
 =?utf-8?B?anl5TGFUb3FLTEdENHFLeDBCSHpFSmI5U0tFdTh6MVh4cWZsTlRSMnc1alJP?=
 =?utf-8?B?d3J5a0RaZnN4Z205U0V2NVc2SWhpOFRMR0hvdjJ6Ukd0NkRCYWU4d0R0Szdv?=
 =?utf-8?B?M3BScmNaaDNha3FqTnZaZUI1a1Z0VUtqdGoxblBXZXhNWWhMOUpYT1ltWFgr?=
 =?utf-8?B?QnhmWHR2c0oyRitZdWJJT1ExRENGb1Y5UTE1YzFFTkt4dEoyWTJkbFFnNVFW?=
 =?utf-8?B?N2MwNXVHeTJqQ2R1ZG53YzJpZmczeHpaY3Y2V1hGbEhoMVlwTVhQdm1YSzA0?=
 =?utf-8?B?UFI2UXFLTm80amJVQldrL2g2ZCszWVVnTnRWNXZCTnpuTFZaMC9wK2dlZTNw?=
 =?utf-8?B?Ry9teUVkeEhEeVNLSUl0K3dzaU1lMFpxS1o3amlIYkFkamN4VHozeTcxSFR0?=
 =?utf-8?B?M1JpcktWbTMycVNYWWhiMzRqZnFQRmFPWFFhTmUralQ4a3hxNUlyeWlLQ1k1?=
 =?utf-8?B?MXFrV3ZQcXdpam5RUFBaOXc1MUdwZ3JsV0JtdTBMNXptU0JnUTFmWndCODIv?=
 =?utf-8?B?QnR0YWo3SWFZU1pHMS83ek01SU1TZlpxeFVuMTFZaXlRSEU1OS9NWWJkR002?=
 =?utf-8?B?cmdOQzRVUzJ6c2VlVUJzY2E3QWF3M0hpbFhxL3RqaVhBZXRxdHpEcDBrSC9O?=
 =?utf-8?B?WXlWVjdMWWJIelZtbVhmSlN3VlBQMU5vc1QzdE1UaTV0QkxURnBhYU95Y0NN?=
 =?utf-8?B?WDgxNEVaQjMxY2RqNWx3dUJjdS82cnRyTkJBc1FtMm1HN2FzS0VibTNCREMw?=
 =?utf-8?B?c2l0cUF2cVJwWHZZcTltbjR5MWllNHNmZHNhRGhnYm12cjJ5enF6K3lOaStG?=
 =?utf-8?B?cjdNaGtwb2I4bUYvc29aUytlWWNEMW5FemsvRDdFRTdvd1JDOHBDa3dRTkJy?=
 =?utf-8?B?MW16Umd5eUZiUEN1aDNHT0lKV0UyL29GR2hITXFQOUNGbVFHc2FTWWhsMlpi?=
 =?utf-8?B?NmF6VUtrTE80VkJWZlhpZXMwWnEyY25YaHR4TnNQZ0RKRjNmTUM4UXFBQVFM?=
 =?utf-8?B?U0FDQnpGSXVjTCt4RXRLdU13ZnNPcldjMjh1YXIrVlM5QncxZXh6UmpFZGNQ?=
 =?utf-8?B?dFRNOHF4dFp1Nm8rcENQbFMvNUl6ajNtWGVDcTBzWk5UZlRQaUw1NFNJb0hk?=
 =?utf-8?B?Z29qTHhYUmVPSVhpektldndWcDd0cU11dnZHc2wyVU9MN0wrQmNIbmtBMDRQ?=
 =?utf-8?B?YjdWaE9HUmF1ZGw3ZFRzTkJHdEpwV3ZzSnIzaStub0JSdGVuV0dHL1VMQWYz?=
 =?utf-8?B?UTZiN21panpjUE0xdzlDS1pUMlVzbXlTWnRlNTlQTVZPdDBFcHdzUXY1Tkh6?=
 =?utf-8?B?eElnK0owRHJpZzVIQmJ2VUZZbWowbWtkRUpUMUtFTW1CaWpvaENxeDk1eExp?=
 =?utf-8?B?dk1QeGQ3bHEwemtsb01wTGJVZ0lxWVNCQ3N4b2NRUERSc0dFR0NNcUVUSTd2?=
 =?utf-8?B?ejE4d0xkNUF1Rk9OVWF1WUZaSTA3L0VjclJDb25oWmhVT2U2OVQ4eTZFeTFX?=
 =?utf-8?B?M1dUZC80bnhFeExtdWV6azRoZFZLQ2dUN0FQUEljakRITERwVmhJVzBFSU9W?=
 =?utf-8?B?K1FWaXR5OE5LM1lWVFEyUUczODh3MzcxWXF3QXJocUQ0d1F1c1lVQVpvdnl5?=
 =?utf-8?B?T3Yzb2hwQ01IcUVJUUVwU21iK0x4ZHNMRGlsbkh6Z3F6Tjc1WVYyWTJzQ2JB?=
 =?utf-8?Q?sbjKRbwnQkfYkpC+yRJwW0kT8lajJxo0SVj4iyJ?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e8707d-3d59-4cfd-2c87-08d979578351
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8340.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 21:18:22.3459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QacSQ7OrFnsb9JTuDY8lbWNvXDLDTvRL7aBfz5Yv+JUlIgqvsksmtoW4z6Y0y/YgIZJx1JejpGBVvU8qOa1WSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6529
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On 09/09/2021 00:37, Erwan Velu wrote:
> [...]
> So I made a try !
>
>
> 2 devices on a single physical core brings me up to 1.23M (that's 67% 
> of the previous result on two physical cores)
>
> 3 devices on a two physical cores bring me up to 1.85M
>
> 4 devices on a two physical cores bring me up to 2.48M
>
> 4 devices on a three physical cores bring me up to 3.77M
>
To ease the reproducer, I created a script 
https://github.com/axboe/fio/pull/1272 that automate all this and fixes 
the usual config mistakes.

Feel free to test it !


