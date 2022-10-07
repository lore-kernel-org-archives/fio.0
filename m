Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB645C433F5
	for <fio@archiver.kernel.org>; Fri,  7 Oct 2022 08:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiJGIcE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 7 Oct 2022 04:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiJGIcC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Oct 2022 04:32:02 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60126.outbound.protection.outlook.com [40.107.6.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8117EB97A2
        for <fio@vger.kernel.org>; Fri,  7 Oct 2022 01:32:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghhktjki1fbv3zsrhIcVTTHFtkX0j3QF9fzmBYHUVIJqCXlZEvsIywYuREP3zBY2UcvRVrU2YM0MuY8GLajfrIkCUwl5TeprB/m8cevy7LrDV0kmbP4aRgLSkNQUaqO+zw26CK6zcqEQWtxI5HfZid/s4oQfhbq0rurJDsGqw09K/b8h2l8xX2nrtppmI1+5BsKLYCWUho3etFSetAtvofU9zTVtOZfdlsK3T5DolaqKcpy7VYChusc/9PSN7bMpaa7fB0LfBkDfLIh6Wr5tfFq/jsIayye4ku12mQkB5LElH/LUuvH5PKtoqU6YiZZT9oODsnMwv9DgxKwbd9u2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSChMfQInnn5dE8cPRCIPzL60k4LZ45iZClF5vYH3hU=;
 b=WyLwj8o3w45s35jRGR6GisSUoYV8iEV/g4XN4hTgvD7AiqdTL50Z6fnnuMjbOIBkXARHSeXW9hQNrAkDxg+wkF6AP/SnXJZJgx8SFONlDqL2NhvNjGHRvr0XijwoyrT9wjImzHIgRgWPjAK+EOGczluUVQYvtIV9caivi04D6YwoRBGozkw9LlIYUSms6TgZgIOluye/hWWYNOgZxhj91m5fFgx1y9jWaQqVQ956OO4Idh9U3ygcu8h+CHr3h/2NA6bd8/okXPbYl9P6ZDzwzUk3pBoHYTWokEfRMLqoOAdiwFpbCcYmErmzjfR3qJ+dSmDEoFBOfc5yYmj2AivBCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSChMfQInnn5dE8cPRCIPzL60k4LZ45iZClF5vYH3hU=;
 b=O24sVlVOX5qIL9NR4o7FBXFH5ehx99u05M/SwS6MciVBw8PfU8W0NHV80VMsLpgqzPBbJKHIwLT7Wv194OStpXiA05/WNusVUHuTFbnDLu2xFGoELHrI2zHTQW893pKP19baXikUXiP0JJAE58KlYRfSe7tY5aWpdbYhnHV6Ito=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=criteo.com;
Received: from PAXPR04MB8989.eurprd04.prod.outlook.com (2603:10a6:102:20c::11)
 by PA4PR04MB7551.eurprd04.prod.outlook.com (2603:10a6:102:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 7 Oct
 2022 08:31:59 +0000
Received: from PAXPR04MB8989.eurprd04.prod.outlook.com
 ([fe80::5e32:7425:68d6:33ad]) by PAXPR04MB8989.eurprd04.prod.outlook.com
 ([fe80::5e32:7425:68d6:33ad%8]) with mapi id 15.20.5676.038; Fri, 7 Oct 2022
 08:31:59 +0000
Message-ID: <9a806c16-ccc4-d31f-e421-87ee93d4fcce@criteo.com>
Date:   Fri, 7 Oct 2022 10:31:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: one-core-peak.sh
Content-Language: en-US
To:     Stephen Bates <sbates@raithlin.com>, fio@vger.kernel.org
Cc:     erwanaliasr1@gmail.com, Martin.Oliveira@eideticom.com,
        info@bytehamster.com
References: <Yz9B4sSqtjH6oKc8@bunbeg>
From:   Erwan Velu <e.velu@criteo.com>
In-Reply-To: <Yz9B4sSqtjH6oKc8@bunbeg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR3PR09CA0018.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::23) To PAXPR04MB8989.eurprd04.prod.outlook.com
 (2603:10a6:102:20c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8989:EE_|PA4PR04MB7551:EE_
X-MS-Office365-Filtering-Correlation-Id: 169a173a-078e-435b-0322-08daa83e66e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BoSBvbhQgGRCnpAhIXwFzLT1O4TUXNHCfmYSbFYleXjh+gR3APbD0a0YWZTH4qq4COOUmmEaVZe+iD0PuOUlSF2HSlJ2YnJsJ6ZnP7XCeM0x6Ohi3r2fX52VzDiHYO7o0FS49TCF2dRUomNCXykapLZurO4sIcG2K6zaprZ6CuXmXTHPyegT8m38D95mXNg7yt8OU9SUdAtlfQ1uUwfRB6BFyOTk044G2XKgShAYIS0mAL7wliShaKC0GlfXzNgYVSBPu8Mq2RQs4RduVaHTnyenCw58J9DHCVG59b5+jFSVhn2b9xK5A1Qx4CopFo+Vh3PYLMlmeYtx7Kfxku66EIZbxkSRuPRHaHE0q8aVhOTHStYouZwDV9GQJ25weH/cSeoXklXiQwhh6S4wIIlwZwzUFblmDPkBhIpyNw4Bd7ES/lDQj89gNHCgtiW+pvqg9ix0wN+7FX3uy9SVhEwhArxdzG9+3tNtJzVFDnnKdO7t+h1JSdOy9xXhH+UiNZAqdMI9qDDIq326ltK0f0hhCwzaLjvZbHyxAWhljJwhNoYtrYU+DKwuSRUZdxCZRyi5jriLuN/0bi7C0U6ay4kZMbJOLMI84OQ5RJm3h3tw4Ynj9GAy5ktTT+AGvHLAODbjTHESP1Vl/FOhClsCQg/DE4XV3IqfYWSOTkIe5dPAyHlqqs29CPFo1JqOSFRcaeugdbawiv7Ep7t0Bh7/k2WJ+ah+CGKPXmf4Zism3/RHdr/QF6X+wGZtpwcu7Lod5HllKjxynbOkHDQf002ZfqJr8zS3HQzS4OH/Gs9duNPo4uCAzmNznBY47RHGQeMMalE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8989.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199015)(86362001)(31696002)(4744005)(36756003)(2906002)(316002)(6486002)(478600001)(2616005)(6506007)(8936002)(3480700007)(66574015)(8676002)(4326008)(66946007)(66556008)(66476007)(41300700001)(186003)(6512007)(38100700002)(5660300002)(31686004)(66899015)(219204002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEZlWXcvbFljaVdlZGZBUks3K0pnL001THNXTk1QbEZDMW1TanhMbEs1WXdX?=
 =?utf-8?B?N1pCT2V3T25PN0Q5SlFwM1N4eVRvNTM5Y2tmdTRLWkw2WVVldG5CZXJhcW1M?=
 =?utf-8?B?V2lzWi8xOFpHeXB2Z0t0WFgrSWRLMVZudWJEdUZmbVg1RWQyWXBtNWwwd01y?=
 =?utf-8?B?LzF3TnQ0SVRyVmhjMkU0N0FEcXl2aVdYeXVLZVFKeXIyMTFFWGVMSzNCK2d6?=
 =?utf-8?B?aFlBaEdDNHk0NXRHeUlud2UxZzRLdkhEdXRhVGU1d0czNXQrSkpReXdoS1Br?=
 =?utf-8?B?dk1zZXg0WWhEUC81RzFVT0wyc3I4YnE3TXNmd0FuVmtBQk51MmNqRm1ldzFm?=
 =?utf-8?B?V1pwU1R1V1ZMM3BpdHJsekl6VFVWM0gxSE5XczJwUFd4bDRxSWhtdEViK2tk?=
 =?utf-8?B?YnorQUgwaHBmbm9zQnM1dTVFSnI5eXlJVzFkZ0NUNlVWUHhmYjlzYTdvMWoy?=
 =?utf-8?B?TkVlR0QwWnZBdUVrSWFtaGdILzRZdGZTSDJqRGptclNyN1N3UGRJN2tCOExk?=
 =?utf-8?B?amZGTnNGRldjU2Mra3FCWFpIbUxnd1dDejd2Mkt4V21BbWc4ZTExOThIVzZw?=
 =?utf-8?B?R0V5bFJPTmNFR1ZoeDdSYkVzeTNUWk9DaTZrZ3M0WEhIWU5vZHRNT3RDZ2Zm?=
 =?utf-8?B?NzBlRm1hTmVTOHA4YzdPSTJhNnVMdjJUcWFWZ0N6a244MkMxWFhCSWJBWmtW?=
 =?utf-8?B?YVRzSTMzd0pwOUpnUWFHQ1p5ZVJScHR3UUpuQURyYzZkZkpuQ1kvNUtzeFhL?=
 =?utf-8?B?RWlqaTVlblNwOVBZOGdlamdvK3h6M2t6QTRPQ3E4bmQ0WnlVd1Q2b3QrUEZh?=
 =?utf-8?B?ZUV0bC9UMUE1VXVveHpEVlVCQSt2VzFvU1JCOWxGWVF3WHdONjBoQytKNTc4?=
 =?utf-8?B?c1p6b2NUQ1ZBTTVnSGN2QllCZ2lJWG04TURnNFVVUE5oZTlnQSszY2JCd01V?=
 =?utf-8?B?Z1dUMFVCYW9CS0pqZnJ5aG5TeHdGT25aOExIZGtsQnZmT0o1V2VrSnlHcmZt?=
 =?utf-8?B?K1U1ZWR5YWpJMjc4cEJISCt4bUIvYytrVmppMHd5c1R4NE53T01NYk5ac3Ns?=
 =?utf-8?B?aTFNL1lnK3ZEeDhRSTdUQmZqS3AvU0RSWEtwclozYnRQbElMTlV2bm0xV25h?=
 =?utf-8?B?Q3NGVW9kZXl3eHpRNTNwRk1RbEdZa214eFI4WVVlOUthUWdodkVYSlc5Rnhs?=
 =?utf-8?B?WXkzUER1WW9WT0tTdXUyZFdMTDU5eEZmTXlZYXJRMjczTENNbnFidzlkeW8r?=
 =?utf-8?B?Z2xSelgxbGNReUdKYjhYWTBYUVQ0amR4djUvRG9rRHR6Ri9rRnQ5R243bDMx?=
 =?utf-8?B?M1U2YkxNODE2T04velVyM1FaUzNaYVlxOWl1ZVRBYm92L2czQnVnTmNWVmlk?=
 =?utf-8?B?MjN5TEJvMC9yUWJWMGk3Rk9nUHFCditYdVU3ZVdCRHo4R0pMaUV1NEZPdkNL?=
 =?utf-8?B?MmlmbWt4WGZ6NFdKQ1M1ZnZPelBQTkJLTjdxRkt6V1A0QldUSk5tT1FsZ3A4?=
 =?utf-8?B?b0ZYZ3dnRDUzeGJlejVGOWkySWtTV0o1T25pTDRYRG9GS1h3L2gvQllGZzBs?=
 =?utf-8?B?b01nRzg1NWNVS2x4MUZ2TEZOc2psaUtWMUlsQzZucXdUcGE4MnhPWmNMN1NZ?=
 =?utf-8?B?MG8rNWVCY0R5SW1DcndUK0htWEtaYlcrYkRqZEpUMDVUeVAwbGI3TWdkWDRt?=
 =?utf-8?B?MDcwN25rU3FpNldNUnR2dHIrdForTnpoYmNGc3FRczlJZGhJb1lSMk8vbU0w?=
 =?utf-8?B?eDRwd2poU1VwdXcrYWtXajlDQk90cWYvSEk4REpETzUzcllWdXA4c25VcTV2?=
 =?utf-8?B?L0lOWnFXVHhJeWMvdjlGWWZiWGpTaHc3MjdxdVRiVWFod2NLdm1rQ3hoNGFx?=
 =?utf-8?B?NWRLNDZGaHBsS1Z4WDVsaEVkWkNqQ2lwbkVkUndmSUxzeFgyNjVaWU5zdlNS?=
 =?utf-8?B?T3V4TlRlS3V4a0FsK1gwLzN4YStzL1NKL09vTEVOdG1UY3cybnBycDZOdVN4?=
 =?utf-8?B?NHlLWFF2WlNDWDRTMW1hTzkvR2s5NEZOUmJGZEdlQldqUkFad1pORUpUMzJz?=
 =?utf-8?B?NXhJN0xSWGN1M1N3RGRYcFV2Zy9GZTdnTkVBaUE2c00ycC8zaEJMTzBJNkZt?=
 =?utf-8?B?VDBoRUpncGd2R1RVS1dpWC9QNXhYSmovL2hkd2lGSlY2Z3l6STdGVG41V055?=
 =?utf-8?Q?aWRym0ExQkHdospWvD159QwtAas4crqSM9Sc+HsBlFnC?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169a173a-078e-435b-0322-08daa83e66e4
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8989.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 08:31:59.5722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dULoup8tNbyqzlNF82dAdUZ8HAwKTU3X4gxwbg86ZcXBQsNO2YXiD2IVO5SrU0FoHZHn7EhRHE+bOTkatpHk5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7551
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Le 06/10/2022 à 23:00, Stephen Bates a écrit :
> Hi All
>
> We are working on measuring one core peak performance and have been
> using the one-core-peak.sh script. While the script does what it needs
> to do we find it a bit hard to use and not written in an ideal
> fashion. We are planning to do a python version which can be done in a
> much cleaner and more readable fashion.
>
> Rather than stomping on toes and just sending a patch to replace this
> script I wanted to solicit feedback from the original authors and
> community that this is acceptable.

Hey,

Thanks for reaching out.

I wrote this tool as a simple helper and though it would be short enough 
to stay in bash.

The bash was clearly a POC more than a solution.

I totally support moving to python3. I can provide help in this.

Erwan,

