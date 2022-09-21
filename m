Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71531C6FA82
	for <fio@archiver.kernel.org>; Wed, 21 Sep 2022 00:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiIUAFk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 20 Sep 2022 20:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiIUAFi (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Sep 2022 20:05:38 -0400
Received: from CAN01-YQB-obe.outbound.protection.outlook.com (mail-yqbcan01on2117.outbound.protection.outlook.com [40.107.116.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764906172C
        for <fio@vger.kernel.org>; Tue, 20 Sep 2022 17:05:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+t66G4Ye9Bvy978IOJ6GfNrurthXGczJQY2tFwRXRnKiXcjwkxjNeaye9MplnnspI/j4WTdW2ce81H8nsnXpTplnXZ6ytsJVSkWLErOY6nZJTmSfUy6soC6x+oY7Na5PucJAwXyXtRVdDdEyljv6uuO7cb0QEKtu01s8zm3EngeCQZaE5QJDBnk4SAqy6yczJ8M+76z3wrlJMoHJNMFqbVe9uqQse673AvDpNeCuWGHSn4AKMXUY3JPJxWEP1wcStIZcXNtHDWjEczCorOfBk94M3CbsSTQgE5SDKHgqH7yAv+DzbR3SoXjJ8F0NZtZI426x8E1AsHJO+XVZiReYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGncVI0S41JGAR/X4k7fDBWkjZXT4R8AOeAGFEBCS6g=;
 b=M28/eQsx/Hwzzr+bLpzzZFSoIIi/vrR7/iTjw+fAdluKi/iceyrXKO/pcQ7F4RaKByJJAPuvo6d/9r+eA/3d7SWddtWGaKrH1E1FKpx0aoFkAR/gvcZx/otbt6oMkc6Et18CNwVLMWr5XSjHHqj/+WyxHiS0AvMu71UstutxLt5PNZYS1XWDAo/QdHaZD5cUMHPYd+yVKoObjomnrEXhDYMgmHj5f+Bxrn77LsRat6QY5+MZmpgKeoR7duizyAr3TidtUmL56cSajHDE/5QnFSVTnggsh3HF+X+XuRyqjlvcKOsiEKDDeSYEjDSIj3R2XaU6FwdjxOMK0DwqFbNDOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGncVI0S41JGAR/X4k7fDBWkjZXT4R8AOeAGFEBCS6g=;
 b=k/R650c4mfhTu5YYtI6EYwd6RiPQnjUle2VNaQxdA6HpmE+ZM6ZH2pmEgR+p1jZ/QsXSSROeyL9KnCmWBvrRJ5v0kcydJLB6lw4BRLaC461Zs3ARn7v4hB1+67LzCbUno/JDO5xG3qnTajKBSUJQX7f63M+15b2VHDUAev3CRZg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1e::7)
 by YT3PR01MB5429.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 00:05:35 +0000
Received: from YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::9039:e2f5:7fca:c6ed]) by YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::9039:e2f5:7fca:c6ed%6]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 00:05:35 +0000
Date:   Tue, 20 Sep 2022 18:05:31 -0600
From:   Stephen Bates <sbates@raithlin.com>
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     fio@vger.kernel.org
Subject: Re: Project to standardize on IOPS per CPU core
Message-ID: <YypVS3B8oegOecd5@bunbeg>
References: <YyoBne389mzhCT8J@ip-172-31-63-112.us-west-2.compute.internal>
 <0ba23bde-1b80-414d-c520-ab39687bf892@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0ba23bde-1b80-414d-c520-ab39687bf892@gmail.com>
X-ClientProxiedBy: MW4PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:303:83::11) To YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQXPR01MB4435:EE_|YT3PR01MB5429:EE_
X-MS-Office365-Filtering-Correlation-Id: c4463985-2c1f-4bb9-c0ff-08da9b65021f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cc4RwBQl6LB0lgVCNdzFSCJ3mF2gnMY1VdL5LBfJpYjnaEjiLF1Lrw+nQLUi1HG6UpYFRsimR8ZNQ1S617un/1Fuh05vHw9pM1BXERM2A/gfOI4wNKoruIbET5uwA/02CqIVu81vs/Lg88pC0lRrcHhBIo4Qe01TJA7ufTqv2oGZNpB8sOhkzZeEb2EM+BWRwpJCfh9/dW8WDMjmjZ9/CnAJlpoe6BEGzHIhA1dD0++rBF9lmekfQCM0IL3ggMJAYUV0yOYjR9KXTppV+9+bhztqjFlt/l7kQSrpb0qz2qihLGDccIfL5d6gm/PApLrcHn0WkHC3eRPtL4gilms0/i8jsX+J2kTfWdXHfAV3Qz5/X9Jf2RHcdMKz1hWCLWVo2sdAhCJphNmfZqFw3upnC2nXvw2DhC+rKzeVmMif7PknyVyIGQTWd9nB4aPLgB7JBlW7jOJt4l6tQ+k/YSMT6Mg+c1aIPP1w/oZ2A0SvMnzwzzKg9PGoW+hDLS7cKmvdNov2hc2eaNLGI+j+t9npcFJXa+E2a7cz2boZMKoCNzZ56+xXXG/3jiNuKwCtsY7XiP/VUBjieN2N0lSx5YQ3WQObZ1g3YhJYDvVc7PgrmXYjielhhtAFhmmRqIx9+lgTH5xUYiU9Glban4j//udW/m/u2pP/40l+BLsRb7jEvA7d9HBc7N3k/Jh4ftTLMcmp/QmIilKHO+ffPlICd2D6UMC9e6UcPdexOOlXzMW8iak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(376002)(396003)(39830400003)(366004)(346002)(451199015)(86362001)(186003)(38100700002)(6666004)(6512007)(6486002)(6506007)(2906002)(53546011)(9686003)(26005)(966005)(478600001)(6916009)(66946007)(316002)(66556008)(41300700001)(4326008)(66476007)(8676002)(5660300002)(8936002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFRDWkM4cE4ySjdiRTAwSzYzZVUvVXhCSmRINEtiNEMwWHFEMXpuVnlhQ2cr?=
 =?utf-8?B?dU1iSnBTTzhiMC8yV2ZYdTRhcE9NZHZGVWV5WDZkckIxajAvemZWTDhOT2Jw?=
 =?utf-8?B?WGxLRlBybGNMc1VkWUgxRjJpMWdCS0FCcnJFVC92b0Z2S0dmVEhFK2g1Mjls?=
 =?utf-8?B?MEIrM0FjM25GTzdPVGlHS3ZTSmR6RlIySHRsK3BDd3VzajdDVlErRUtMMUw1?=
 =?utf-8?B?UDFQSHJXZW9VQU9vVWZaYW1rZWpwZHRFaGhpUkVUbjhYcERQYWpxTWhtenQ0?=
 =?utf-8?B?ZEhTa3hxT2dnQytobjNpSDVGUnpQUEw4ak1CeXgvUVI1dXlsQkp0aUZ4Ly9Y?=
 =?utf-8?B?eGJLRVJwaFFUSHhlNUpqZy9xOFpOTzdneEEyUUJQNGoySmFnZTNnUFFtRkd2?=
 =?utf-8?B?SkFiMlVMMlQxbXJjMGViYzR0Ynl4T3lHTHhTQ2J1NWFaNnZ2a0RYVzdhbXdD?=
 =?utf-8?B?THFJRllKVDBaRGdrNXZ6Y0lPaktkVUFad0Y0d2tta2pza1YyKytyODgwMGhu?=
 =?utf-8?B?QTJPSWRsRXJnc21ET1NIQm0rUFcrUDVidHpScFlyanBTSjlLQ3BrMS9ETW9u?=
 =?utf-8?B?dHFEb0JvZUdNYi9wR0VLTG03QTlIQmdiaG95T2kyTmEyTVpIbDVWUGUzb1dw?=
 =?utf-8?B?aWt2Y0NZY1ZuQittdVFQbWlKRks2UU1NWmFkdUF4a2kvcnA4TmNEZFhUWncz?=
 =?utf-8?B?NkV2NG9lRDU3UjZDQU1HREw5d2QwT080dU5JUmJPanpUTjVSOS9OcTdxVytk?=
 =?utf-8?B?bUc4M3hLeVdZQ1RxRUkzd1A3Z0V3Ym9PQnVvN2pkMFZhTEpKSVc4dFV0dURk?=
 =?utf-8?B?UXkyb2JDSnVWYU55dy92bDVjem9vdE9QdGxYcy9yUG85d1JpTkpHajM3S3p3?=
 =?utf-8?B?cStJMzg0dDRJV1M4M3BZeDlyM2hmYnFPUWFYb2hKU0tPQlJMSzgxZFRYZkhi?=
 =?utf-8?B?L2ZkdjdVaHFrcTFFQndMa216a3ZEWGlyUUJic2hmT0NSMXhZd3dlS1ZEdWVl?=
 =?utf-8?B?N0Y5QnZtcGNobWQ1M1REMXVWOTgvdlNxM2ZTQk1WMXZiSGpVVko4OU84MVkx?=
 =?utf-8?B?dzFBZVpXRGYyQW1BbDJFNVNlR3ZuUlc3VDQwQW5qWTNiRWZ2b3lWeTFsb09r?=
 =?utf-8?B?MXlWYndNUU9DN3hpMmVVWDZJVSt5eFpPVERpQkRQZm9EV2tOSWlsQ3IvS3pw?=
 =?utf-8?B?cng0MndaRnJjQWNTaXU1RitnaEp2U1NXYllCZ3UyZ25HWm5oeDZuZ2VnbzZ6?=
 =?utf-8?B?bk9KR2VYNWU0bm1IVEhaSFhtNTJPTVM4bmVSekJyd2xsbXk5dTRoNFNUNVdw?=
 =?utf-8?B?Q284VmJXa2FsSGMzYlR5TVdOUDdObzU3OEYvRFRQb05EY1VHbTVIN3ZNT2NX?=
 =?utf-8?B?dmVnTGNiSjFMQlY3SGc2c1hNUlZkOFU5TUk2c2V4aFUrbnByNzByOFUrU1Nm?=
 =?utf-8?B?Y08zMFJFcGdWS25DUHhLWDB0V1k5a3UvYytELzAyY0NidXdVSDZCVWhGTmk2?=
 =?utf-8?B?RWxRM3QrZCt0ZHh3d3lDQnRlL0pzU2R2ejBjZWdCZEtCWnJRZndpMnV2d2o0?=
 =?utf-8?B?bTJLYldWZ2hhaFRBTFIydjkvWk5zOEo4ckl5djlkaHo1NzFINmpXRDhGMHFZ?=
 =?utf-8?B?VzZOc3dLbmdsS0hseFpsWDdRY3VmODhRR3RTRjdNNDRNcjZKanpmZWlOSDd4?=
 =?utf-8?B?U0llUk1ZdFErM2tQM1RaUlR0N3JHMmQzT1VrRG1wYktMUGpheFVUUVZpS2RY?=
 =?utf-8?B?eFI2eldKSmZoSmc0N0lUR05iNlNYaGtBMStuR2hDMlJDcDlyTEpic1pLR3Er?=
 =?utf-8?B?SXVMdm1leEpzNXZRYnpYUksyM3JNMUZYeFpYKzE5WGc3Z2lOQUozRmc2VkJI?=
 =?utf-8?B?MTIvRWJPYW9SeHkzVGZsY1E5Vm1UVHMwM2dDVDN0NzZSMmFWS1JyL1BaeGdR?=
 =?utf-8?B?cGRFVkM4V1Rka0FzTWpVQk1JZGhRaEFUNEwvR3lSMTdrN1NWRlBRY3B1MlNh?=
 =?utf-8?B?YXIzRmZhaXNyWVFmM0JvZDNrSm0rUGhmaVNpTFZOMGlaTFlWMGpycUlJYll1?=
 =?utf-8?B?ZEFnVVNCRzhrdm9zdGttMWlQZHFjNmFpcFVLVk9IazdadVdQN2RpM1UxZms3?=
 =?utf-8?Q?joTIQLNOsmqwP6JCiSQkIDtSC?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4463985-2c1f-4bb9-c0ff-08da9b65021f
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:05:35.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ybNvtH1Ot4mTPwhw6W3egOt0/T9dWXaX/OOcOMZUNXRGi+HCO+pv5IUfpbTk8k2PdAGhxXYGSeAPDS02Doo8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5429
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The 09/20/2022 17:47, Vincent Fu wrote:
> On 9/20/22 14:08, Stephen Bates wrote:
> > Hi fio'ers
> > 
> > I have been working with a few others on NVMe performance in a range
> > of different environments. At the same time I have been tracking some
> > of the reports on IOPS per core for NVMe+io_uring [1][2]. I was hoping
> > to create a standrd and repeatable test for this using a mix of
> > packer, Ansible and AWS machines.
> > 
> > The idea would be a scriptable flow to obtain a working
> > fio+libiouring+kernel on some AWS EC2 instance(s) and then automate
> > some tests to obtain IOPS per CPU core.
> > 
> > To help me get started on this does anyone have any pointers on how
> > best to configure the system to maximize this metric? Also any fio
> > scripts for this that people can point me too would be excellent.
> > 
> > If there is interest I would happily work this into a patch for fio
> > (perhaps in some sort of CI way).
> > 
> > Cheers
> > 
> > Stephen Bates, PhD.
> > 
> > [1]: https://www.phoronix.com/news/7.4M-IOPS-Linux-Per-Core
> > [2]: https://twitter.com/axboe/status/1452689372395053062?lang=en
> 
> Stephen, t/one-core-peak.sh was added last year by Erwan Velu and might be
> useful to you:
> 
> https://github.com/axboe/fio/blob/master/t/one-core-peak.sh
> 
> Vincent

Vincent

Oh thanks! This is great. I will take a look at this and go from there.

-- 

Cheers

Stephen Bates, PhD.
