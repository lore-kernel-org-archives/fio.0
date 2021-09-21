Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E06C433F5
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 07:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBD661183
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 07:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhIUHHc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Sep 2021 03:07:32 -0400
Received: from mail-eopbgr30116.outbound.protection.outlook.com ([40.107.3.116]:46656
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229999AbhIUHH3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Sep 2021 03:07:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1dKeuw++zifKHZtrQCsmYzIV0IG9kGusG98gl/q5DO4bvel8qxD0YcwtJ4EdOZSHpQFZlZpNT7j4yoXaMF3HPFDsEMBlNxkzQnAKVt8TiPzp9fK3S2C8cYVvdsW1gMvEKG2w2nGpJ+ZJaXNj4dcAk6NvIHN7zKALe4Qc0Nhjg7hPL8dREXBgro0j/RwDHBkTGnNZEq3MsysiE9JzXbEiacf9dAUdykYFJUlHTZ/KPSxYWPoeZB5cavgcEqvqWv5rBBWuSwUgs3Q4Vb5c8Yz/KX8g4EUdJ5pmz2F9fBztKZp7sYSG0py2owjkTiEpy8txZVSFhIOktX9qVMwD8yCbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GjzIOuLBG86aiMlxtU75/O40Q8ve0TLS6blyktMzw24=;
 b=odjfjoaV21SosDWopz9ojVk66OpHmi4nJdz7HmFGW7A2uEy4iR/XYeR8gQvqi4rSZuhAYd7Sw7PldcNYtV33qHvclxc4AODk4UHv7A9uZs1vuTp2D19mQgS0VrWtTg6JX9QUWSReBplP35kgzJ6yTbWZm1jefKrzouFUAlptz0P9PLwxD4yNJfcoTBOYunQLOn+bxxupl4JZUX6trWO6nvF4IHNxDYtqHh8twQtRKcCahqYH1KnqVGfZ+KAcMD5PCL2uKNfWJyFmpYre4zYZqbap4dh6IzeZdmrsMKve8EDUDVWFH8fPYYIBwZVFOecYM8MZbKtVgiHC/YuzqqaDiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjzIOuLBG86aiMlxtU75/O40Q8ve0TLS6blyktMzw24=;
 b=XmuxLKPgstngvI2Jo+mv5LsC4sNFAjdzQVIni+MwO/Ak/nMDLBST3dyEfWC9txEM/vPO1RmaZB/LdGDkdHR768Km4MBh1waPyuiqQP+7u1UtD9pQxfq+Aa2K80VKgp9ppqe1NVBq7Tu9wAxQKInb22awna/iAm0Rxx6jm2WMd9Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com (2603:10a6:20b:3e0::23)
 by AM0PR04MB5267.eurprd04.prod.outlook.com (2603:10a6:208:d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Tue, 21 Sep
 2021 07:05:58 +0000
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::6468:321a:74dd:5b62]) by AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::6468:321a:74dd:5b62%6]) with mapi id 15.20.4523.019; Tue, 21 Sep 2021
 07:05:58 +0000
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
 <796c8f29-323a-6fbc-09fc-5c739c81a221@criteo.com>
Message-ID: <abf13615-4243-e102-5c1d-cb252c679b1a@criteo.com>
Date:   Tue, 21 Sep 2021 09:05:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <796c8f29-323a-6fbc-09fc-5c739c81a221@criteo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR0P264CA0064.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::28) To AM9PR04MB8340.eurprd04.prod.outlook.com
 (2603:10a6:20b:3e0::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:de8:8800:9f39:f0bc:7320:844] (2a01:cb00:de8:8800:9f39:f0bc:7320:844) by PR0P264CA0064.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 07:05:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63778739-2e58-42d1-d3cd-08d97cce430d
X-MS-TrafficTypeDiagnostic: AM0PR04MB5267:
X-Microsoft-Antispam-PRVS: <AM0PR04MB526770DB258022D2A0E7277FF2A19@AM0PR04MB5267.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EfdCsNDpWjELOt5EJBPS+tDpfYMGXrn17Ws5HCf1BrfnbS8gKq/+x5T0bptKv9bktcMsofjFaK5xKoWKnaJanxPbh83jFKvPN2xGjrJDPZxxBRlRhXH7Od/9IYU+L1ieP/XMZ0kWo9OszjtvZtpUQQPKDyhpKFrV04HWhUiPyEN/n8koOjj80AmMN8nK4QqUHJ6Sw3POgtW9BnVqrPq+tTomnqFHtNwZ4Zx6Dtt429uu6f91vaHrVAUS9yhOlHPihRHfhRcOxaT9pJobnmyv3wXOAIRsvUeX9+NUen3KRD+TzGWSm4D3bN9z/87LMROOUlybeVjmtV21GZt3fNMVuhIpZT9n046p6QXgtG2zDwBhDh3Ym4DlUfSQMzmtX5L6Ep1/jJMOqAwoAtVzgKjUkmdIYlxvmDhEIkcNbpNNHIStgOnd99pUKk9Y4T5lnEAZKt7BT+ZAX88SnywYy/Dy6Y47hs9WqbWR4d0/jivNzwxONgQ3FSpNbSZJh5Of/hjJV1L1zioMPpZJQpJwv6yDX1Ikf1BCF/7tQf7sMjsFWixcN8IRDJmhW/MSQMH/TERcB15wayCnm/GY4DaQDGEWLyZJzsSxD9D/ZXo4fURvqPu8R+I5T3XJB0GwxHKgYRs51PvdFwwYonzCGlcaMy6myJ3ZPzH/SeM3DKTe3N4LECz+Pax3LElh7FdQlWhup79SW6Syz8c8PecrpMGyyglIImfhZWzxhxF51L9ojOyIM5MCaWV5YEuBjJcLZDwd5gO4tgzcTvJKHi6GgfFDTN1OnX0ReTVkPpRRN2U2dYCh9zzUNZbIbNqe0SgOXKmFeq2gVfxoky65yjCXXtXxIVSEf31tn9RQW/OC2W87+JzqaXM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8340.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(8936002)(966005)(2906002)(66556008)(66476007)(52116002)(66946007)(53546011)(36756003)(31696002)(316002)(86362001)(2616005)(6486002)(508600001)(45080400002)(5660300002)(31686004)(110136005)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHJyQW1HWFVodzNWQlhsbFExclZmbUNWUFMzT3JVd1Q1cUJtM0sxZURWcnJM?=
 =?utf-8?B?NlIvUDA0RnpxUzgxcUE2elAybjdZZkZvb0tJSmpzR0tTdm5DSTl0aGRoZ0Zu?=
 =?utf-8?B?SlQxNHNTOGU4dUNBYmhFZkZNbWp4QmhjQTBNVWNKWlRSS0J4eDBzRURCY0Mw?=
 =?utf-8?B?RklWWUNiTkJibEpTTkRUbGpUcElsMlFBME1mMnRjN3dvMnpNRnh4bFptbUxH?=
 =?utf-8?B?UFBEdFB2emp6Vk9xZzJRajFIUDNRKzA3bjJuWnVWNFRPeWRtY292NDJXd3RR?=
 =?utf-8?B?WHBUQitsWkxzUFVmRmJONllpR3ZqS2FnTGlpYUZuRHZSVDVGTjJyK0h1WFlD?=
 =?utf-8?B?a2E2dWxEaWZQUGpaSjBQUVJranFPdVoxSFlObEVnNGNDNjNWT3ViZFk2VFda?=
 =?utf-8?B?Q0FrbFRvQm4rUlZuVEVHbDIxSFZPdGcwYmdaRDdlN2x6UC9lMmFpVG9UYytK?=
 =?utf-8?B?M2t1SERkWUNHQnNndU96b2xoUDU3bHhYL1h0Q2YyeCtGNmpWRWZYRkMxS3l5?=
 =?utf-8?B?T2d5dDVmdytqV3FQdFo4a1hETUc0Rnc2LzIvUGFJVVBhUVFEZE54c1BMTWpQ?=
 =?utf-8?B?aXpmWU1kSkZvZWxMb0xiUFkzUEtCdU4ydlAvMmFlMVVwcGFMNWo2NnRnUkE3?=
 =?utf-8?B?OVRvNVRLaEl0MEtPTHc2bUp3bVdMUnhCNno2SFEvd0ttK2NLOFY1TEozSjZE?=
 =?utf-8?B?WXpOVWxEQ25PR29JcmdLbEtlTlppY2M2ckM1OFM1UFhFVThNQ01kaGFOY0hJ?=
 =?utf-8?B?ZFZJOW5uekUydGwyN0M4RTZKeDNLeGdYZkpBazlKRk80SDd0aTFDU3pobUhY?=
 =?utf-8?B?QkFUWkpCcjkzNW9wbVZoN3dJRWtjd290MDZRS3ZyRk9yYnhFaXlneDNCd25H?=
 =?utf-8?B?NFA0SHpXMndhc3VZN09TcVRBejdSNkR6K1NjdEM4d3NBd2oxelo5WVZNV1Nu?=
 =?utf-8?B?emw4TXZnQ1lyc2s0S3gvTGdpc0k4L3NXek9ZNm1Da3J3YkpjOFBRQUZsRVNV?=
 =?utf-8?B?NXJXT2h4K1F3NWdZVzcreXNwcEswRForR1FvM2huelpJdndkSkNsZGswTzF2?=
 =?utf-8?B?dmdmc1hTanp4bnpuN04zSW9QWXBzMzhCN1pCL3g5STFNbWNuY25TZExVWmYv?=
 =?utf-8?B?STErTnpWV0FOWGV6RzNIU3U2UEt3OGVnNXRKQlhxblNUaEF0YmVnMjdJenZy?=
 =?utf-8?B?UDR5ejN2M1IreW54RjVYUWgrdkszaUM0b0lIVVBmNkJCaDRxME1lU0w5OHIr?=
 =?utf-8?B?cWhmVUNJRFdadDdTanRpMk53YXliZUxMd25FNk8zN0lyV2VVeFkvRkZhLzhL?=
 =?utf-8?B?OHhwUGsvbzd1R0JFN3h6eXJwNGVZNGxEQWpnakdaR2xaMjFMZkZWVjBxczV6?=
 =?utf-8?B?Z0xHMHBybjI4bnBDNkgrNGJNSTBxZms1R2I1MmxVVXRWM1Z3WlEydE1OZTR0?=
 =?utf-8?B?TEZzbEJNbUNNb0VXUlRQRHVqQnBuQTliZXdOSThSUXgvNDRjblFsajRic0gv?=
 =?utf-8?B?UVZodWFHY2J6OHQ4cXJvT1F1MDdVWXNhdEVQSFVIaDlZZEZieENHaGRDS2Y3?=
 =?utf-8?B?N0Y1Mzc0bkt5MHpGZjA0WXR2T0xQVDE5cnVmUGlhcVRSR1RLVUVWRTAyL3Vk?=
 =?utf-8?B?WFNpbURUelpKeWFsRUJOTGpXV1ZwMGFKemYwZFd6U3FqcnJHdTlIWmNDNlNk?=
 =?utf-8?B?QWtwYUxZNGZWdThDMXVRN280cFAwcHVYaW9VZEF0VVRpdjlrQjVQR2E1QnVK?=
 =?utf-8?B?UG9MT3lNUXR1UmdUaTFnWlBhM0R4bk9DTVdQMW9TUUlxejVnWldUMFcxVThl?=
 =?utf-8?B?cEVDeFpyYWlvRjA3dzZpU3ZyOEExaG5nTE0yQWk3QkZ2a01mcFhRQlFDQk02?=
 =?utf-8?Q?2FQh2WhywOBqM?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63778739-2e58-42d1-d3cd-08d97cce430d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8340.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 07:05:58.1226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WLsBf8daRbp4M5YshaRMNTMBU8yIebJBh3fVlWOmYX/R/esUY6/oqLBAsMzfXjewFdIfz39ZDiIiRznJwGiWlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5267
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Le 16/09/2021 à 23:18, Erwan Velu a écrit :
>
> On 09/09/2021 00:37, Erwan Velu wrote:
>> [...]
>> So I made a try !
>>
>>
>> 2 devices on a single physical core brings me up to 1.23M (that's 67% 
>> of the previous result on two physical cores)
>>
>> 3 devices on a two physical cores bring me up to 1.85M
>>
>> 4 devices on a two physical cores bring me up to 2.48M
>>
>> 4 devices on a three physical cores bring me up to 3.77M
>>
> To ease the reproducer, I created a script 
> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Faxboe%2Ffio%2Fpull%2F1272&amp;data=04%7C01%7Ce.velu%40criteo.com%7C790c95d308a04c6e9c4308d9795785f5%7C2a35d8fd574d48e3927c8c398e225a01%7C1%7C0%7C637674239079752317%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=vBAwZnAJzkSAag3k6PW2kCDBStrap5rM1joFWuaG6MY%3D&amp;reserved=0 
> that automate all this and fixes the usual config mistakes.
>
> Feel free to test it !

Just merged by Jens : 
https://github.com/axboe/fio/commit/0c6c0ebb82504da41ff2aa7a382923d9713b40ab

Feel free to use t/one-core-peak.sh to test your setup, feel free to 
comment & patch.

Erwan,

