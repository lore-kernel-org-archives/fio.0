Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6DAC433EF
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 14:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbiFNO3X (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245755AbiFNO2u (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 10:28:50 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80092.outbound.protection.outlook.com [40.107.8.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1A5B867
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 07:28:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FURyFiNqJL4WrSzSyxlSTiwjh+8xb48b6s6kZamBjQix9LO7dvUUA/HX5f/KXZ9Rn27UdX56gEk+1it2f2MRcr9iy3+hsbR0M8u+fLge0djJKGYg1LPGjsmFtrz8qwbkGzrVemQbyfZWrCOfvV7mouVf0RX6h1ARgpRMzeDl/dqC72H3gGDhGbI8edgDOjmRVTnm8XPLXzWNYNErCeXryUWfLYMqjsh62eihGmGUeQ8uaXtMlDOG7fTYVjIAkeAX1G0kOQlhzqr6Ipfm53LN2nA6EcWAUjwumE1ro7Vn/Ch0DWallECItQeCVD7UdbOfiIZw+0dTQBQNyHB5DYsO0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yaxkbqnj4roCfi4fpXOML5ZGWhHuK4MYV560Z80pWEM=;
 b=VT4VBEsX12SWhICw0RbCNhB7D0XOfBmEwlGKerJTQNxCNkKUkkhodd1I5H5BrPfZ/jAOSW9ng2THEnPL7l8p9e2TUvhCbj7zTNHkJRhUmcKzp+3pd0VLDbXn/i5b4FMkLIAiPZ564uW1lbiqEc5HOqs6naHVCYeuRA0KQpa3WuZWYRegoAeACuloNM7W6P0EqmqhlPEv+DwSL0CFTyeIMHmclWjGhTNMIgdKtQ6xRSxO/GgVVHM/3QugO1tdnTYKHKCF5DNfMwHVek6HidSb77hV84UTvbutg7+n+vltbo5hLtX49gUqTZ8pzVdK6gLZA2/p6sA/AFgUG2BhoYKs0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yaxkbqnj4roCfi4fpXOML5ZGWhHuK4MYV560Z80pWEM=;
 b=fCicLXCsPM4ecDspqzlanvicYrCAGWzRTyiTXu+pb3BA62D7BdvDIzYNdWablBBSFfpSXFLinAnfBy5s44W7b6fiVOxGI5zJVWh4U/2sJg0CR/zQIaVzzrpFwlDQpDM2x8PpBOCJcIP7tgnGr25PoQuNrBW0hptW3XNJFHWucik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=criteo.com;
Received: from PAXPR04MB8989.eurprd04.prod.outlook.com (2603:10a6:102:20c::11)
 by VI1PR04MB5199.eurprd04.prod.outlook.com (2603:10a6:803:62::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 14:28:45 +0000
Received: from PAXPR04MB8989.eurprd04.prod.outlook.com
 ([fe80::bce7:c24b:6ad9:7c7b]) by PAXPR04MB8989.eurprd04.prod.outlook.com
 ([fe80::bce7:c24b:6ad9:7c7b%7]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 14:28:45 +0000
Message-ID: <19a2559f-05e5-b597-fa28-2822af13bd85@criteo.com>
Date:   Tue, 14 Jun 2022 16:28:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Blog post on how fio measures latency
Content-Language: en-US
To:     Vincent Fu <vincentfu@gmail.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, gost.dev@samsung.com
References: <b862c6ba-ba87-bf1d-b695-4529e19335a6@gmail.com>
From:   Erwan Velu <e.velu@criteo.com>
In-Reply-To: <b862c6ba-ba87-bf1d-b695-4529e19335a6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR3P251CA0004.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::16) To PAXPR04MB8989.eurprd04.prod.outlook.com
 (2603:10a6:102:20c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65ea8e81-3251-4df9-19c0-08da4e123044
X-MS-TrafficTypeDiagnostic: VI1PR04MB5199:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB519989B01C841CADB8A2A3EFF2AA9@VI1PR04MB5199.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oakhV0CvuM6pH+6JGaFjd72QScM0jdxBFMFrFM/UQp94g2sPo81H1TtNPjyfFlSK5ac2AX6a46Yq+4kzW2UwcyFtTAi2BB5qPgner2euNLsay5850oS7Pimq7oQ1wyp7PH7qrCzMWeER2oYRepO1CiKxOdyXpxN88CTP1AEeqnBGjx+TBi/SwkACF8TdmHh1wW5anHRS56iMphmsS4HiO5JrBBkNAqK0JGFLa/0FbJf96ZUPa/6vu7tJzJwjseWPNTZ9+MCIovbED9MqaT7dhKCe0Dl5kkyMNm3bpzg+Qjzk9b2qBfn5HO78zm2KkyZNGDy/DBDCDN7u+zKUaB9jzh8bcN1YfLdp2B2Eks9uaV+hy09XXAMadYeEPMoOY3UUOGwn7MoeRyvo9toH/d7PZo8sGifcU0oDOfzgSCVQJz2RmL6+eTsgoDcDAB3YP9QDYILY8urSLV8JgZtR5fmUH0yQX3VOv/YQ8ojPEvMiVy9JHCNP8fYA8WesiffkK9wbdoarJmL6IAk0EPBdQiRLYw4qZVhXUl4LgHThBVOZRxL4nzsRFBdOj26BuTxzoFJZx0kqSttwiV0k/qDQ4WYHdIvFK5SRGV9qYbPEhsPAXMly9DZGJ95hCbqsbjgNjf25AYhpKqQ28J/XfgLj9BrybhGicmi6dt0m5iQg94U/8Ha6maRzII7DKNEVqQv9ZsuvgHy475wmpBrjpfEN9zzkwZceLpSrEf/ENI3wNoJ8bxXO9Q7DGIulBq4KXBtQ2k1aI9ViT/JtAkYQWEZ0u7uuilUPTHt6XTm1nAPUYreWxs3FY6+ThKk1jTjVij0PAbU6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8989.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(66556008)(4744005)(66476007)(66946007)(45080400002)(6486002)(2906002)(36756003)(38100700002)(186003)(966005)(508600001)(6506007)(2616005)(110136005)(8676002)(31696002)(86362001)(31686004)(5660300002)(316002)(26005)(8936002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2FwS3QxcUFJTDc1aTFCdWRHR2NwdkNTc0F1dVNCNnhiVHlxbjJ1b0k5bmt2?=
 =?utf-8?B?R2ppSXdoZEF6Y3RPdnBZTWlwQ1lIY2xxbkJiODJYRmt5ZC9oL1ZjVXNPNlQ5?=
 =?utf-8?B?TFFFOTdab1FRVWNwaERqWGUwdndvZmNoYW1TNHRNYUZKblNpSmxjZ05TeFdU?=
 =?utf-8?B?WVBqU3Y2L1BRblBzOGhBcUprd1FYNmlJM3FvZllsSno4cSsvcEsvWDNWSFFU?=
 =?utf-8?B?OVpkckxqNkl2NE8wWW1xTWxiTHZpMjIxUmxnR3VyWmQ5OFVPNzFJRVhqYVh3?=
 =?utf-8?B?UEJObjZ5d2ozYXlGOHpxYkphckMvZ1M4UjlUejJac0FCWnFaQnZsRWtGNVBC?=
 =?utf-8?B?Ny9MME8xYU5uai9qT0tpOFYwM05nSi9hS1JyaHlmbk1NNkk3Wjh3cS9wK2N2?=
 =?utf-8?B?L2lqSjRXODJYYmR2bHN1TGdiM0FXc1MzeEVuYXFFbWpNZVl3VzJ1dG5oSDBq?=
 =?utf-8?B?dTVSRjN5TUJyOGNNWFdUZXhWSmluTnZUTjM2YUkvd0dRNWVMUnQ1bkZGMnJ6?=
 =?utf-8?B?SWRSdzlReTFVRHpNWFV6bU84aTdvcjVqd05TVUpDZ09oVzBrM0JCN3lMOVpS?=
 =?utf-8?B?eXJaTHVGbWdEbjBjTFNZNXZxZFdIV1VSL0JvZGFSUmNHZ2pnWmJ5Uk1IUzNT?=
 =?utf-8?B?M3JDNWxwNjR2aFBoeUk3aGx0WTJHb1VFOU5mOXVNMmhvMWJ5Z0Q5QVZxYzBz?=
 =?utf-8?B?ZlE3bGF0N3ZOVHdRMGxhU1I4ck8zWS8xVW94QmxSWDZQT1RIcVVXeXllbnRv?=
 =?utf-8?B?Q0dqa21GUTl4RVBFaTIveExnOVQwUTRqdlVYNk5ENkVXcU0yZGJjbUtOQmRN?=
 =?utf-8?B?QUUwRkxJS3dYZDZVUDRPQUJCNnp3VWpDY1UxT2dTbGpoVkJReFNQT053dzZ2?=
 =?utf-8?B?M1JzRXNiZ2F1L2tseGtQUWE5MWQxb3Q5Ni85QjR4QWVhZkNIUk1FZkF4K3RM?=
 =?utf-8?B?cFlTOTh6SnNVYmF0R0U0Rm10MGtEb1FIRTZ3L0lTR1NwYnQ5bWdEZTRXd0J5?=
 =?utf-8?B?N1N1VkJoR3cxd1RWdTh0d3YzbFYvdTJIREFjdVEwT1ZZVUF6Ly9xL1JxcG9n?=
 =?utf-8?B?bTFjTWlzdjJFWWVkWUdDditVMzVWR1h6TVBKOEN3YjNJb1I0T0V5bW02bm53?=
 =?utf-8?B?UW5Rb3dqQ3JMNldOdHFMUFV0SGV2VnliZUpTNjdNN2FJZUFKSVNmcVcyQTVn?=
 =?utf-8?B?eWFVcWtEVGpzV2dDLzI5VXpBVnl1OS9hNmpsb1pScldsckQ2TFdqaDJVemh1?=
 =?utf-8?B?K09SY0U1ZDE1ZVlhZ2RTZHFUMHVQRXlNbEpzbUdNSDBPZERPOGNkdTNJUlVw?=
 =?utf-8?B?Ni9sU29UdFBFaTNlQnBQM3VNRFpxdU1MVnJTZkpkeHIwQ1lobmIyL2xENnVm?=
 =?utf-8?B?eTMzQ0EyRkFNU1pxUVVZOFVMNDlVakU0QVVlYU1oYUJPRFFQUms5NGtVaU9x?=
 =?utf-8?B?Q0JoQ2Eranl4MTd0MHliSWp4MnhrNVZYb1dQVzdWRHRqdDdON3AzT3VYN1Zq?=
 =?utf-8?B?WmYrZUdxUkNmR1BCTGZCdUp5ZGFtV3Z5dnl6UXcxOExHRzQ3NG9WdTN0azVx?=
 =?utf-8?B?VnJYeExYRnA1K3RlSy9oRXlZb21BeFFqS01lYlhFMWxOUXRoSTdRTlJZcFhp?=
 =?utf-8?B?cWJXTG9OWUgwSm5XY29GeEY0WEo2MUdxK29KemRFdXJpWmo5NzEzMHVEQTBX?=
 =?utf-8?B?REREdFRRSS9pV3pqcytxeHdwOGhPZjVkQncrbmhLcitWUUhJNjF1WC9IdDRO?=
 =?utf-8?B?YzBTWkVOVmpTZnR6RHQ4TnoxSWl5QUFsUmcrYVRkOVdndlUwcVl5dFpBZDRm?=
 =?utf-8?B?T3YzMFk3LzhjK0FjZnBDdkEwVHZkTnBwYnVxcWtobVJCYlpicFJ0QTVUcmRo?=
 =?utf-8?B?TnZiai9uOFFSeFJud29jeU9GcytLY2hGYjBGYWNuMlZrbGFhbDlYTGhDT1A0?=
 =?utf-8?B?UTRzWDBBSWJVbUp2d1hERTZWUFFkOUF5aU1VUFBOREpZbmtuVEttWlRoRFY4?=
 =?utf-8?B?Rkc5VXFOcUR0Ui9SN0dtMXU2WUloU2o2VVR0aGF2amQxSGpkYmxYT0VicTZO?=
 =?utf-8?B?S3k1Vm00SVZkVUt0TGZvZ3NZODM5Y0xsTjlmUW93ZDV6WXFDTy9sTURhMDNp?=
 =?utf-8?B?YnErV0g5WGJIb1RlOFhIdHRNUmJyZmh2cUdBZVFrc01IYWE5MGUrRUREYStL?=
 =?utf-8?B?Q2VzVlExdDNtYW1UOXRIdDQvVGlYbmNyVXR5NHN0MnBaRFdZcDRnSFg4TmFS?=
 =?utf-8?B?RTlmT0ZYaWN5ak9jM1JsWlpmSE1Hb0JhWWQxRGVkM01pbE4za1JQeDNuYVVk?=
 =?utf-8?B?R1FVSkFLRmhwdXpIbEFDZzZIbW9QUEM2T09LYnBYNUZIek5WeitOQT09?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ea8e81-3251-4df9-19c0-08da4e123044
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8989.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 14:28:45.3587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O+Xvvngg5MYx2uJACLGZo6psbTwhEA9uoSFj69pEIpE3qMYLI82llWXJ7V2WRoLE7fgF8jfAtpw89yDl3VYK6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5199
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Le 09/06/2022 à 15:46, Vincent Fu a écrit :
> I have a new blog post describing how fio measures latency:
>
> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fvincentkfu%2Ffio-blog%2Fwiki%2FHow-does-fio-measure-latency&amp;data=05%7C01%7Ce.velu%40criteo.com%7C6463c5b6ca2548d415dd08da4a1e7138%7C2a35d8fd574d48e3927c8c398e225a01%7C1%7C0%7C637903791846076175%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=1XZ6jj%2FgOHjDGolytLdXxv%2FA8OR6CmqHKCj%2FgRGUgjw%3D&amp;reserved=0 
>
>
> Feedback is welcome!
>
Thanks, that's awesome to get such details.

Why not having this as part of the doc/ directory of the project ? That 
could be used by new comers to learn about fio.

Erwan,


