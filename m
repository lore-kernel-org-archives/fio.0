Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C7DC433F5
	for <fio@archiver.kernel.org>; Fri,  7 Oct 2022 17:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJGReE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 7 Oct 2022 13:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJGReB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Oct 2022 13:34:01 -0400
Received: from CAN01-YT3-obe.outbound.protection.outlook.com (mail-yt3can01on2123.outbound.protection.outlook.com [40.107.115.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34952D18E9
        for <fio@vger.kernel.org>; Fri,  7 Oct 2022 10:33:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HazNEc4Iz5a1yqyBzR8VjX2Yi5Ktl6NQaCo/Jz2SOd3JzVZi0wLHrYZ1SatWVCZ6D3x2kN4ITwEplCGYfrYaqggQ46EGVeheCZyTcvypL/cHzlBpbB53vlaZEysre1vVk9RFptRH7TF95JnJuV+9LLady8RZlzBi1SV9xLycw4COoZpa5T+gP+bNL4ybAMR6uWuS14Q+ZqliPeEdmdFdvEI1MDvlYWTwsni34S58hjAzSEDDbGLcP7bqxhbABCHe+p/uXVe8ufuTFHfcIIOBwWB8GI0nnARJmst6piMj/FaFSomDUONMe9kjChweFU8yjJ8zeJpwGespcXTEWswFDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFdq2vGllMm0v5n3vMEg9KNsVSsdOE830ehK7neK8Ig=;
 b=YHMmudEV8XdGcSHaZ9g1eL+g32oP5YBlS7/DRSkkO8vY3+izIboDA9Ix2o2SSJWCL73kwRed8QPZKQ9syKwt5GY5Uu6j5YSlrlBkbuTkbmd22YZ1tDOmbmc6ic0RGEED6pgd98mKmmbCnbs4oHocV7f2qylG3QHBI9rMrjwibGmmmLFH6YmRj0IW8lsk0u7+LtD4ooN92sRMKLOafR9z0O9F4sMzE6PsYAy8/RaMTpJnptjf8IXwvQXceG9tcgSDXnwbPgmIivLCf746sTKtR9HjLEjkEPC7pJFKd6V0wFRIi6ziEtgJRJ2WdFYxrXnCzGzJ0Oau3Fet/+HJERdzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFdq2vGllMm0v5n3vMEg9KNsVSsdOE830ehK7neK8Ig=;
 b=o7yVjrxgITmVNDsIWjNEM6Urt+vFoUXkl86WIBocar7uHr1w5pOih9D7Ffh+mzZ0NFOGUgB8aybmfvEqY35GmAcaE7cq2UZSg6xgQA2XL6Xk9jHtdDERdma2dUGWtTVKQWwRix/rqHqxDk39nU/sWmR3C2maIQa4iCJu0k1GMCY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1e::7)
 by YT3PR01MB5954.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:5f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.31; Fri, 7 Oct
 2022 17:33:55 +0000
Received: from YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::9039:e2f5:7fca:c6ed]) by YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::9039:e2f5:7fca:c6ed%7]) with mapi id 15.20.5709.015; Fri, 7 Oct 2022
 17:33:55 +0000
Date:   Fri, 7 Oct 2022 11:33:47 -0600
From:   Stephen Bates <sbates@raithlin.com>
To:     Erwan Velu <e.velu@criteo.com>
Cc:     fio@vger.kernel.org, erwanaliasr1@gmail.com,
        Martin.Oliveira@eideticom.com, info@bytehamster.com
Subject: Re: one-core-peak.sh
Message-ID: <Y0Bi+zovJvCha4Gy@bunbeg>
References: <Yz9B4sSqtjH6oKc8@bunbeg>
 <9a806c16-ccc4-d31f-e421-87ee93d4fcce@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a806c16-ccc4-d31f-e421-87ee93d4fcce@criteo.com>
X-ClientProxiedBy: MW4PR04CA0339.namprd04.prod.outlook.com
 (2603:10b6:303:8a::14) To YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQXPR01MB4435:EE_|YT3PR01MB5954:EE_
X-MS-Office365-Filtering-Correlation-Id: d90d2f22-e9e3-43bd-a9f6-08daa88a1c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hityhMPJUKQG83r6IeZ4LinX1pEMJL1rSy0RWZmZjc+u4H3Q7/G7Y2Yd3S//tJ3XG1tbMnmrL5E8fukZwNTM1JQPS9b+pjID3PFaKlUbu9c4Q3UswSW8VgYKQ7Y9hgLhVCpJBzqAP+jIXJg7WHJXSkpqiDByrHKSxSiyrN2n5KyHBB/FvXclnrhYm/NHnSUjXGwC5r7jhhtOldNLVUMM67gCx3h/bza7wHGpEZ/62OZFe6HQsPx0GlOgjpwKm6eUAMGCPxwc55WyPADFt5YQN6qm960C/wRh54q5DzC7tnZ+DBGet+xSowkIFL4WObBxir5jwjAKdzmKa0Fes9XS1mIhAe5lAo/4wvtcJnqVJhG/8Qjr/1zCccGY2J7KDVK2/VNrhsEmTxrK4MawOtRn03uO/e7SbK+lOKcwdgmMjvS5vKqX/Mw19BO9RD3V997o0+yxleLf75oVAmy8VzG+LY+we7CqI9GD3oPq8JPJzCSuyWb9dBe3sWbNIbTQ35ndJ84KPfhewCEO4AWMSj6M7b2KB2iIvwLqs+rTWoMCJfljttIbHYTsd/sZuZM1haZXSRz5846pMxyLxJWqQYaQxWTA+Wdk1mITzrANLiIktdjVdMIdYHStRRlRy2AujixNWCKjZbGalsHDGCHFaS6qi7Al/hMe/kfs3SRzCwZnmSf8tVZGUFCNAcYRTJNbzwJGq+EXftgeHRZakvTP2wrc3fFn7Jwfi74KZy5Lje36HJj13aYpRvTjVL9r0XIn/rkNcEhy568wvoL1+dmHhrYoZMjy57jw9FmI01QTmf+teKOPklLgwsn99WL6YsEXcGgL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(376002)(39830400003)(366004)(346002)(396003)(451199015)(66899015)(8936002)(41300700001)(66574015)(5660300002)(478600001)(38100700002)(6916009)(66946007)(6666004)(966005)(2906002)(6486002)(66476007)(9686003)(6512007)(66556008)(186003)(26005)(316002)(86362001)(4326008)(33716001)(3480700007)(8676002)(6506007)(219204002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTlOcHNsVkFlaEVoSXA1RC8zdTJDUFRjbXQyQmpRN3Yvc3RNbThuaFNtbTUx?=
 =?utf-8?B?ckNydmI3d3AwdUdTalR2WUs2YmF5dXRVUS96OG1aTDBRU0JrQ0ZnTzd6eVgz?=
 =?utf-8?B?cDVRZEdFWmdMRGt4NStTWkdyS0V4YXY5U0tkdzhMY29La3lpcm52azN5TTgw?=
 =?utf-8?B?ZjBWUFdZSWVJQVplSUw1QXducTkzMVJ6Umo4Mjd3NlZjYnY5TkZqVFFuamRP?=
 =?utf-8?B?Wk9DcGlxTXcxRFQ1L3lMU3B2dkdPZUE0dE5Od1BlNDBVMUt5SW1IcGhVQWxN?=
 =?utf-8?B?Y2JDZENXRnAxeHFlQlJJZVpSUWNzbSsxOEl3MlZoQTlPZ3g3bUJKajBRTkht?=
 =?utf-8?B?MHdXelJ0aHQ5L1BLMWlFMHdpRi8yblBHRjBNeGJJN3I0MzhOWHRiUVZYRDVE?=
 =?utf-8?B?V0xUTFZFRE5BT0xSY2FGdzJIUGx1a3lOdW8xdXZoTDlJZUNoUnR3V1FjRXFY?=
 =?utf-8?B?Y1VQVk51L3Z1dGVEUllhM01SejZBVlptQUFEREtVY01Lc2ZPeVFPU0ZDSUkv?=
 =?utf-8?B?ajFWNHpHbmdnWllReEptNjlsRWxvNmM5eHFjL2w3NWdCYjRJUUY2eFpLcHVr?=
 =?utf-8?B?OWdYNFk5MVBwREFkaEdjMS9FRVhNekIrT1JRdGtVZHF2VzZ1NW5hTCsxenZo?=
 =?utf-8?B?dUZLS1Y2bXMwbVNVOUtZYnN4MjZCcWVxWndmOEZBcHJOSU1tSWpHTk54WkFV?=
 =?utf-8?B?K0IvTVR3Yld3TGVEQ0VkZGJiVUNGcDk1aWR4SURnTmk0VXdFNG9oZTNrcmNX?=
 =?utf-8?B?b1NncXlONEZoYWxqeHY3OEZRNlFHSEwxYjExR1hxeTU1YTFTOHdITGhKcHlB?=
 =?utf-8?B?aHFjRTI1eTVLbVFUZlJrOGN3UlJ6QUk1MjFvaURMZkhDazYyei9VV2NxbUJO?=
 =?utf-8?B?TmhUbTE3clAyRFFrVEExTWxJZ2tpNlFHaDBwTjlQUThJOVBvK2E4WVBhUkZC?=
 =?utf-8?B?cU5lTzNubUhsNlhrcEVrOEtscFQ2YTB3SGI4enFCRWRQQStIWlFES1hkWkgv?=
 =?utf-8?B?UnVxQTBmSkhLQTZ4dHh4NXE1eHEyQ2ZBOFVDc3ZvNnhjQWF3MlFEYlBrS3I4?=
 =?utf-8?B?TTdRVWhsemFhYXNIRkhscGkwdnJqR2pON2p5VU9PSmpHWnp3WkhpTGdRSVRJ?=
 =?utf-8?B?eGtkV0l6VzJmTmN2d21EQWEreVJmY2hSbC9BNHVKeGh5bDJBdGFPa25ESUQr?=
 =?utf-8?B?R3VLenhVQVlBZXpVZkhNa3h1ck5UQ0NVMzFRcW9MSmcxUzdnemUyWjh6MlZv?=
 =?utf-8?B?d0I1YzRpUzFlbGVnaWJPbGtFTnh0WFV0c3BReElSSGg4V3RKQmpyOER0cERr?=
 =?utf-8?B?SE4wQThwSHBNS0JiRy9CVGdZNnU3ZzRJSVJSM0NqMHcwaWZZd0RpaGhjY0tJ?=
 =?utf-8?B?dHVOcVZ5OEo0c1F1ZC9mU09YWGdZYUx2WE5Zb3VtNW5oV0JZcElHQjNRUm9u?=
 =?utf-8?B?NWo3YUpSZ2NQZzdhT0ZDcCs4NnFQMzAwZ2pKSVZBL001Tk04UlpqcXZaSzVC?=
 =?utf-8?B?eVQ3VzBxMEMxTnM5cjdtMkNNanhRYXdtVG8raFluUlVIaVE5Um5RV3BRYmor?=
 =?utf-8?B?Y2tlQm5IRU1JbXdsNmRHSFZsRUxpdG9pRndxY2VScXFaNWtmVktIWHBpU0Fy?=
 =?utf-8?B?a1FtWC9UTjErbHYxZDR3TDR0UGRjZGY5dFgyTVdxeDBYUGltQ244SDRiUWNp?=
 =?utf-8?B?TUNWTzlRZDl1NzZqZmxPbW9tNS9WL1RqRTVxR3kyY0ZSVkdOZVBWc21hZXVI?=
 =?utf-8?B?QXFhMmhTR1prTFZiYnJrZ3BQY0kvR0R1d1QvU1pVazZHYTJnOUxPOUd6Umtq?=
 =?utf-8?B?TGlJbnNubFgweW5KMGQzUWVnVndzUjRidmtOdUpuZ3ZqK0lXVDRUaVZpYW1I?=
 =?utf-8?B?RHpTQ1BlYWFxRSszSi9BbTcyR0hWcXAvVERpa2J0ekZCdVQ1UjNQM0g0ZVZJ?=
 =?utf-8?B?NVgrWjRuNmRsOGpleGdQT1RneklyWC9CWEcybS84S0hXeHZSTjRqMW91RXNa?=
 =?utf-8?B?TStha2o4SEpkT1R6QmhyN2FneWRJdTVWOGlaQmxYS3RpS2FSUXV2d2lXL0cw?=
 =?utf-8?B?TDVaamFZUmV6RjBMWExFNkhYZ0NzZCtmUFM3S2l3dDdVWWJqTCs5aE9xT1A5?=
 =?utf-8?Q?LU9bZvHlU5AhCTJqskn7NZ9gv?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90d2f22-e9e3-43bd-a9f6-08daa88a1c07
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 17:33:55.6813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ypzz6VVhT8cUUNosRdKPbW0e+V0LfwgmTaBu4uxLPjXGXRZfyZsst0WoPexwM1es9affXfvQUEWnUVlBO2IgUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5954
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The 10/07/2022 10:31, Erwan Velu wrote:
> Le 06/10/2022 à 23:00, Stephen Bates a écrit :
> > Hi All
> > 
> > We are working on measuring one core peak performance and have been
> > using the one-core-peak.sh script. While the script does what it needs
> > to do we find it a bit hard to use and not written in an ideal
> > fashion. We are planning to do a python version which can be done in a
> > much cleaner and more readable fashion.
> > 
> > Rather than stomping on toes and just sending a patch to replace this
> > script I wanted to solicit feedback from the original authors and
> > community that this is acceptable.
> 
> Hey,
> 
> Thanks for reaching out.
> 
> I wrote this tool as a simple helper and though it would be short enough to
> stay in bash.
> 
> The bash was clearly a POC more than a solution.
> 
> I totally support moving to python3. I can provide help in this.
> 
> Erwan,
>

Hi Erwan

Thanks for responding! I have opened an issue on Jen's GitHub repo [1]. If you or anyone else fancy collaborating on this please reach out to me. We can work on my fork of fio [2] if it suits and then prepare a patchset.

-- 

Cheers

Stephen

[1]: https://github.com/axboe/fio/issues/1476
[2]: https://github.com/sbates130272/fio
