Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1695C636CC
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 19:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbjBCTIy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 14:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjBCTIq (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 14:08:46 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12olkn2107.outbound.protection.outlook.com [40.92.23.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB331AE85E
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 11:08:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nodcoes1FtKwgImID5Q61g2FopmN16AaYtkJGoUbUXYfNMoz6lbx1z90aGYiogYUO0m+FhjhXhgsBHyIWmNflQxUfaBKRRpJQh/7A+mK1qODaIyXZ3XVr2pqNQZ7vcHvxIgtBZr+MIL/O+LxPf4JPqJAxLNLqFVgqmYqQORD48GBXTy96t+jYVtUGbW+hNTs/zNP4WX6eBLS4L6Wk7UiY97JkERK67IDqeVY58cffhSK8Burkr8/Cr7tckErjXPmIYjgMzR00C+iwz2uLSN4xag3kQMBjtJvTh0fabL3gwXU4Xn58WGOMwCbXh4iPSSlLkB4j80fyL//cCqWZRVezw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xm4+z7gciltz7c+B+KAFwYJtaGsYhBjIKejyhlYB1KU=;
 b=FHvrSEAZWASY2eHtUFjNsGk/0ZNbWcoQ84ZhIJtbJT35B/MyZfXWhXxqd3DggGj0WGlD/U47GTQpFYETOKlTnhloRsuDto7g9k3YOhFNLtXS9xtz8nGqemyDxp71lwC4FQ2iIXQ8V9nkhsO/J8OhDijjOIWXYKQ5hUTcc5gNIX10RzR7orMPV8DROlOsaNIAFnIzUQwdgpgTXIp0kHN6Iw2+tWeTdLUBQfTiDgulwO+90Q3s2yJy4M6UolRBmaP8TcYc3v471MFiVwHkuDLRbRmEf2NKIODDnEILpyi4QtJ4VhNhiwiY8AEXcwcSM5S8jWWq/TKygkV3+Bf6y4DZJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xm4+z7gciltz7c+B+KAFwYJtaGsYhBjIKejyhlYB1KU=;
 b=VNrYh9U9ndCrL84DpRc2sRI1vhIl7gCEiXoyw6cO3P4gi0mzNNEnwmb+qdtiOBpy35b3OBv16NPEqsOxqowm1WOMnboITg5kxA22SUgQPmPDFTpvA7Jin9mrlHua/BfpKjuW19Xzf9udQQ6rmJGQOvVuh5YVpW4mtgLAUpj77ii2/4Sb1izR5g38lA7sGX7P7hPQO7zxPeF5aovtgri/aNUBmsu8ecbv5yMes3hlO4et5GmwyM4quPQ4MPB11+IVkWWQfCWNhmFnJTKvxndo5Fq45zCIlUdhUx9VS54npe8bZFOww134b4OBP1oVtyvXCmhFVbiDJP+iz7tWN27szw==
Received: from SJ0PR10MB4815.namprd10.prod.outlook.com (2603:10b6:a03:2da::17)
 by PH7PR10MB6309.namprd10.prod.outlook.com (2603:10b6:510:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Fri, 3 Feb
 2023 19:08:39 +0000
Received: from SJ0PR10MB4815.namprd10.prod.outlook.com
 ([fe80::54e9:3b8e:b881:a31f]) by SJ0PR10MB4815.namprd10.prod.outlook.com
 ([fe80::54e9:3b8e:b881:a31f%5]) with mapi id 15.20.6086.007; Fri, 3 Feb 2023
 19:08:39 +0000
Message-ID: <SJ0PR10MB4815C6B3A7BA1DF411B86159A4D79@SJ0PR10MB4815.namprd10.prod.outlook.com>
Date:   Fri, 3 Feb 2023 14:08:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
From:   Adam Horshack <horshack@live.com>
Subject: Adding stale-data detection to verify logic
To:     fio@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [AOFxn8d0DUceiYtLckWMEVEmCLcR/ImN]
X-ClientProxiedBy: BN0PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:408:e4::34) To SJ0PR10MB4815.namprd10.prod.outlook.com
 (2603:10b6:a03:2da::17)
X-Microsoft-Original-Message-ID: <e65748ac-b257-793b-cdfe-50e07bdddce2@live.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4815:EE_|PH7PR10MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d4c4d5d-adeb-4825-bc6b-08db061a0edf
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYK0SOc49d/BUhm4Ix31dzFzCqa06EnMCMgWu/mJ2H8UiD8ZstKHJusHSvkNuuU4MvolyjZhjHJB1/ol04lS+iw58kZ7cQz/Xb3VyhzQpKKOsqw6fOZsH7S7BzoHxTzw1vrj9TDEssuUMFqP4vhbo8Uz95e/1wLNXyS4Ut1YYJUX1jVmDBlv2eQmtNOUraSfQGB3ynNkgOMQKs30W7PwenlQHGAXLdpoT8hS/dy/5mzodkpvM6hWUva6x/9LytCOnIsa9qDKPQWcugntdp6r9FDf73R5fZvn03axu3ki82Ca4Rg1Ho3JO1UGOTKS71mUqlz+hkoT7deMFyMknO83kJo5Xvje9iicDDYICIsDM9giVuGffaPs7aCp7WSL41duhjIgWIVf3yz/2BbMYXsDImo6QRT5p16MaLdiXVhLE0y+leb71mq1nQwuQL3ux/AqxnIDD+MdQUpJJukwL+acHaj14XoW6sI2JutnUW4WZlbpdcLiVILkUd6Xsp6ux2T6XUyc1nEWi85ngVpJpzUntdxsu2ejSG+zMpBwif4VY3x7LiJI0O8xfPTqDBNy5XwUqXBk/N8sjvTbYxFeg4+96wTPUg0L4QQMC0Lq4Sl+V+0=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDAyRDAvMFB0UkwvbVFSdDNWTzJoTkpjK0U5eHMyV3VQQzVsM3B4LytMMEQy?=
 =?utf-8?B?Q0Y5N0tRVzk1emhOYmNWZlEzdVJVa3ZaSTRTcDJSNXRUTWVPTUZ2R0VrZjRm?=
 =?utf-8?B?dXdVeEVDY29HVFN4NDgwaXZER2tIbDlnaDVnNUJSalJvZ2RjQUV3UW8rL1Nk?=
 =?utf-8?B?ckYyUldtWEl4VkhEOWNyU2VMSDB6VlJPRUJXNXJPMHRHcnhLR3VobFhmOVpK?=
 =?utf-8?B?WGgzSHlxM3JqcXQ1Q2Q0Ykl1RWVIMHlTM04vdDRCaUVqVEFjZHFIZEtjYUJL?=
 =?utf-8?B?TEk3TmhTbUg3ZXZ6YXcybWN2TlJNbnZTMWovWlR4QUFwUUtkZlZEMGZZNGp0?=
 =?utf-8?B?SzJ4cDU2SEpCR0IrZFoxUzFLM2NvcFF6SG5BTDhoNE91ODBMd1Z2QTRQeFZI?=
 =?utf-8?B?UTJiem1SdmtjUmNFazdRUFZrNml6SnBqUEI5R1gzK2pnU2dPbGtsWEM2Q05N?=
 =?utf-8?B?TjZXTE1vYlBMNnBvUE1pMmtDOGVRNW1Dck1aNVI2SWowTnVnSjlTeXZvaFB4?=
 =?utf-8?B?MElkUzZ0S1haRy9hMEhRcTN0d2VRajZOTHZMZEkzcEFkMlo5UVRqZW9tdVJ2?=
 =?utf-8?B?VmlHeVA4Vkh2RWhzMUZYbTFNR0NiOWloeTBUUWVNN3NXb2I4QlB2K0x1cHNL?=
 =?utf-8?B?dEFPckYvMHFDMDdadERZWXFUZE5jbjFJZ0oySEl6L1BIN3lwZW5RdlpkNUJh?=
 =?utf-8?B?T29sNmxiMDNReEpsdjM4UFlhVTA1SzNsaTVINVExTjNJYVVWdGZ2cVppdEdo?=
 =?utf-8?B?U2FrMklsZ3J4WENZeFFXK1lvWUFHVUpmY0o4VS9sdWl2TjkycmxsRWFreDhZ?=
 =?utf-8?B?Vm5jaGptd1pvdUZzdzREV2YxOEVSd29ZVllyQXFHYTF3RXBydFVkcjdyS2l6?=
 =?utf-8?B?TXB6OWg2RFY3bEkzYUVoaWdSK1ZSampMWEVHMXNoZEZpSkxjR3RibUphRzNh?=
 =?utf-8?B?RG10YzA4RHB3VWFEdFphcVIrQU5idThFTHNFcnptV1U3TktzajcwQ1V3N1RO?=
 =?utf-8?B?ejhtYjl1U0VUeE9MTURFWkx0anVjdjU3SmdsdWZnMVhrclhFRjR1bElOS1VN?=
 =?utf-8?B?WGc0WHpzZUhnY0I1aW1XMzg4SFhwZHg1RlFrZEhzKzVXUTVXeEJEQVl3VTRp?=
 =?utf-8?B?dHJjaWVhZ1dXcVhQYTZzSElkRHQyZnZyUTJ5aFdMYlFkNS9qY2QyVVJCWGVo?=
 =?utf-8?B?RitHbjhDYnc4SHVXcGd3emt1Z25CcDdiWGkxd0JwdjhGejgxY1BDRnFZQnpm?=
 =?utf-8?B?UHk2UVROMEs0NEtMVjdScDdJK0NkczN4aldBYXcrODJBTVV6Q1p2L1JtSVZy?=
 =?utf-8?B?Nkl5NlJBczVJQU14WGhETjVmbTZCZ2c0eDRzYXJCc2ZnY0VNbUk4QVBKRzcy?=
 =?utf-8?B?V2EyQ1ZNRVlFc3oxY0lCMzNsbmthMzY4dXVDd2dhUFFKZTF0blBpeVViNDdF?=
 =?utf-8?B?QTdoVW1VZnNCUWtBL2cwd1h6UUFheGhBajdnOUtKMUdZOWVMczhxSGR3RUk4?=
 =?utf-8?B?UVdTM0x1a3AxeG1ISEM2TjVJSlIwV0ZuWjVpMUZuSlVnSHRlMlNlZ3F6S1BC?=
 =?utf-8?B?N2dROGp5U0hzTlp5UlBBNWxuOXRuZ1dPVmVFcVJzOXU5ODJhN0tMOWRIS0hS?=
 =?utf-8?B?MDlkUjJxQWNOa05iNFAyOFBEUEN5Y0E0U0VieE1FL21RUXhJdnB4UDJRTGNh?=
 =?utf-8?B?Sm90YW1Ea0lQalVmV3ZidDhXM2ZDbXg3RUNjTFFuK3loUVVaL3lOMmp3PT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-28291.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d4c4d5d-adeb-4825-bc6b-08db061a0edf
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4815.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 19:08:39.3235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6309
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

As written the verify function doesn't appear to have logic for 
detecting dropped-writes (stale data) for data at rest. There are only 
two temporally-variant fields presently utilized in the verify pattern:

verify_header.rand_seed
verify_header.numberio

These fields are verified during read+write invocations but not for 
read-only invocations. This means any dropped data for the most recent 
write to a given block won't be detected because all the non-temporally 
variant fields will pass verification. This is particularly problematic 
when reusing a device for separate fio invocations during a series of 
tests, as there will be valid but stale data at rest from previous 
invocations.

For example, if a user does the following after previous fio invocations:

1) Performs a write workload, without verify. When complete, runs a 
subsequent invocation with a read/verify-only workload against the same 
dataset.

2) Performs a write workload and use a trigger to perform a 
power-interruption test. Run a subsequent invocation with a 
read/verify-only workload, using verify_state_load=1.

It could be argued the onus is on the user to wipe data before every 
invocation but I'm not sure that's reasonable.

I'd like to implement an invocation-variant check that will catch the 
case of any data at rest stale relative to previous invocations. There 
would be an invocation-unique identifier, either passed via a 
command-line option or generated randomly. It would be added to 
verify_header and checked during all verify-reads. To support its use 
for subsequent read-only invocations it would be added to the 
verify_state file and used whenever verify_state_load=1. It would also 
be utilized when the identifier is specified on the command line.

An alternative would be to use the existing verify_header.time_sec field 
and check for any blocks older than the start time of the most recent 
invocation time that we'd encode in the state file. This would make a 
command-line option for specifying the time a little more cumbersome 
than an opaque identifier.

Note this wont catch missed multiple writes within a given invocation as 
that would require a block-specific sidecar map that tracks write counts 
per block (or stores a subset of the hash for the most recent write for 
each block). I've implemented such a feature in a proprietary tool and 
would consider it for fio if there's interest. The downside is the 
creation and dependency of a large side-car file. The upside is it would 
add verification support for sparsely-random workloads.

Code references for the temporal-variant field not being used for 
read-only workloads:

verify_io_u() forces the seeds to match the header's seed when !td_rw():

/*
  * Make rand_seed check pass when have verify_backlog or
  * zone reset frequency for zonemode=zbd.
  */
if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG) ||
     td->o.zrf.u.f)
     io_u->rand_seed = hdr->rand_seed;

verify_header() bypasses numberio check for read-only invocations:

/*
  * For read-only workloads, the program cannot be certain of the
  * last numberio written to a block. Checking of numberio will be
  * done only for workloads that write data.  For verify_only,
  * numberio check is skipped.
  */
if (td_write(td) && (td_min_bs(td) == td_max_bs(td)) &&
     !td->o.time_based)
     if (!td->o.verify_only)
         if (hdr->numberio != io_u->numberio) {
             log_err("verify: bad header numberio %"PRIu16
                 ", wanted %"PRIu16,
                 hdr->numberio, io_u->numberio);
             goto err;
         }

Adam (horshack@live.com)
