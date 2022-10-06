Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF8FC433F5
	for <fio@archiver.kernel.org>; Thu,  6 Oct 2022 21:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiJFVAc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Oct 2022 17:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiJFVAb (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Oct 2022 17:00:31 -0400
Received: from CAN01-YQB-obe.outbound.protection.outlook.com (mail-yqbcan01on2113.outbound.protection.outlook.com [40.107.116.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203DEA4871
        for <fio@vger.kernel.org>; Thu,  6 Oct 2022 14:00:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqtGzRQcncXefQT3nF2HR2Ejet5D7ZRmuYVbRW0Hza9E896eMkvel2Yvbt++nVzctTWJNFGOB1PK1q/4ys8/Ruxc1PbodrM11K7CR69honlqokTuufPoGIV0YHBwL891bvd4irbdb2mTe+8F+PI/A6eoKax4tCl5x07oltZlNjKDE6QRnSIxWEArucvdJtwGWIopnsW92dWJW+ApJgCkCgp/qusYUp5CvQXtWmvthgkyvWpJus8+/KCU4/o+PlHGiNr8ezm2bIX9oNcPb3xmcIYWKiWeJslJxT53FbYzVFtKLDvlV727fIl6vU85DzNMSMd0Fb1hiwztxdbRn+Wh5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcJK/Q1s1BfCqAOD3kI2MAgap594DTN+zjijKIzxhos=;
 b=YseXK1fwll099xh06TSTykkzWY6VkGvVWsEK+ceXxRdsLHImpUCICEO4MwvXEFF/BZy6O7wdwgsTUxf36QnKpbnopUCel44zCSciopTVEq03QeIwPr7vRu5e5OFDpFSC2Q8P2HPl2mlizHV/txifg3NJHGaA1vtPCOKIYQUGSTcB+MECyYHduPPNMRYFPYCAU+rKsN4uKndd4vngZm5rcauzdt+VbvyqHHYtCs+JooKPrNhCGLDJoKQCl3CB9LDkZwjeFQONdoShSWt/4EaY2sNdMt/YmUPb9Ce/KyumO+jBOK6kbVBiIIZ57uZ+px4g9GO3+2jhaIgw7JuxPK+SqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcJK/Q1s1BfCqAOD3kI2MAgap594DTN+zjijKIzxhos=;
 b=EMCFjNeQzbS6IFPdk//DiqyovzybpMZnVAfu8Osn8Z4ds4zIbklvZXQqfano9vGfzaqkAfFgvH9i16CtZRwpFy0xhpj+4MUiaYRfH98mI2QALDrtQsN0NqW55rflI/Aipe2mN7X3qgaPuFYIoES3Jgsghsd32SUg5+Q2OHrfJrk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1e::7)
 by YQXPR01MB5803.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.36; Thu, 6 Oct
 2022 21:00:23 +0000
Received: from YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::9039:e2f5:7fca:c6ed]) by YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::9039:e2f5:7fca:c6ed%7]) with mapi id 15.20.5676.034; Thu, 6 Oct 2022
 21:00:23 +0000
Date:   Thu, 6 Oct 2022 15:00:18 -0600
From:   Stephen Bates <sbates@raithlin.com>
To:     fio@vger.kernel.org
Cc:     erwanaliasr1@gmail.com, Martin.Oliveira@eideticom.com,
        info@bytehamster.com
Subject: one-core-peak.sh
Message-ID: <Yz9B4sSqtjH6oKc8@bunbeg>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-ClientProxiedBy: MW4P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::30) To YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQXPR01MB4435:EE_|YQXPR01MB5803:EE_
X-MS-Office365-Filtering-Correlation-Id: 79b1d381-ff82-41d6-6744-08daa7ddc8ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTCAdIaxg/HBonw85w2T1HNvLrDeHW69v4DPY3i9nemeRGV6MLiwRZtUIKZey1btV53C19Yu9gwL35fpXvcqKBhf369ypUsaOQArWjCMj/0vHRVkt2ivBrBbaRdENKfmxJnlrPRWMnGW/g5qLRKxgeGZ66lYxtdB34Ib1lT1R75oN/U7eCkakguz4W/1hME48nWP6lWF0fDl9yVCZ5RYFqRSo0DBspFOOP3FsOZUdoUMU21JULrmnZYv1UPbBcc9GO+od54HjwVBycJLNd58rOb1hU21W1XtR4+h7E4cWUz1TEZ4QeWoF7GZvC5i9Y47QV4sZFDkHsDC3ulX2RfjXZGcusc5+yLcczPM1E1I2RW5u2PUgWUcQ7a1KNYtpHqQ25QOhYL6c9Qadg0MXkpmQornWFzmnTJaIhMNFF73ZNLDlzXKmo2YuUDFtMWP9VleEeauoL5eOj/kCIHekV3Fgb9sZ0x5Gl/uIyQjogsndnflEQWhUIzUXiH6ANyRUAK+xs4K1ok1VTCGqAznZ3NKOQIhYKDhjPl73a3BgIpzFFmQvgiuaruhKdEXa39EpvOeD4h+632hN+xw3KNgpwGpNJWLVXsF2fqjtoXQQbW3WO+f8bT3vKiSYh87ziNuXOQRfNHLOVqA08Bw40k4SBb7DzpT/Mf+q9ce+kMZ2iQYMa/y7npg19F5ofuU/pm3/W0dBd06uCfesIjZWUmGSAGyHOykSES3vkYDuxdy57MjYl13gtLAh4ZPTDoHSnvT55Bt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(346002)(376002)(136003)(39830400003)(366004)(451199015)(3480700007)(38100700002)(4326008)(8676002)(66946007)(66556008)(66476007)(2906002)(6916009)(316002)(41300700001)(8936002)(33716001)(5660300002)(186003)(4744005)(6486002)(478600001)(9686003)(6512007)(26005)(6506007)(6666004)(86362001)(66899015)(219204002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTYrZUN3WC85NlU1ZDAybXdRcEJVenFYNzJCNUVKQ1ArK1ErQmxUTFpxZ2FG?=
 =?utf-8?B?Yzk2VHUyeFdoRUxWbC9lT3RoMC9lNkluMXJ6T0xJNjRtQnJSWm54N1AvelYx?=
 =?utf-8?B?TkdFNzV0ZVFzejI1aVpHZWhMUmlGSGdTSCt6Mnl6OXduZDBPZUxMd1hjdUhI?=
 =?utf-8?B?eFdPZEhZdVZhR2pRdHN4aE1LMXNEQnF1V2Y0Nk5CVDZoU1kydDZxbXRxSjRt?=
 =?utf-8?B?ZjI2VVVldWJTWjlHdHpjUzJyazY0VlpjZnhPbEs2Ym80T0Z0RlJKall0QnZh?=
 =?utf-8?B?WmpGNTB5NmN1MXc2dTJQYUFmV0xJNG5rVGhKOTQvUiswbVVzVG9JbnFiT3Jq?=
 =?utf-8?B?QVo1MzFId0c0NUY2OTZJeVMyUkZDZDIzZExjNTRhWHdLczJqendoc0c1b1BO?=
 =?utf-8?B?b1RQUkVWZzdocjRwZHdIc3FvYzNLd0FDekphWFVJZmhwVlpOTlcyV3RGOFhZ?=
 =?utf-8?B?MGV2UGlOVmN0OENoY1k3VGxWUk5RYUZDMEFKM0haYXpHSW82K1FxbTY3ZDVG?=
 =?utf-8?B?ZnJTRi9pTFBYNnl0TUI3YS8walVkZ0xrL2ZSdnRURU5RdzE4d3ZlS0U3RXJu?=
 =?utf-8?B?QnhPd3FhOEZUbmREeGdRZndiM0E1d2ovMThtb1c5SlBUZ3UzaTVIMmNld0xF?=
 =?utf-8?B?cFllOUJzMUljaFZJTVg2c2JnNDhRQ1BEMis1bXhCOStZUzd1bFgrT0JGd0wv?=
 =?utf-8?B?TGlUakxDZzNGSFllSUdDdnJld083M01kRUpjUE9IczI5VW4vWmRHd1I3eWpC?=
 =?utf-8?B?MklSUTNoaGh6RWsybHZKUnBETHhLb041eVlDc1IwWDRjZk4wWlR5bEhkMU1K?=
 =?utf-8?B?cDBJS25CSW85eGdVL2VncmVrVGpGTUszZGI2c1NIZ295ekxDT1U1cTVmYmN0?=
 =?utf-8?B?QWIxdWdGbHJwOVlEWjF0cVdRMVZxeWN4czBFZWpFSVl4UGNISjQ2Q21HM1lD?=
 =?utf-8?B?SGdPNGVLMEo4NjArSWlJUld5MndMcklTcFVmeEpvVGQ1cjJzVkluK3ZpbXBh?=
 =?utf-8?B?VHEzYXZ3ZnJtbm5UaFBTam10QjlXTitxQjB1alpGUlR0Yy9PVHNWbmVMaUpu?=
 =?utf-8?B?TTUwK05vMlIxSFZDQkp0SHRYSjNKNXM4ai9pdTYyQkNNU1M5enNVRVc1NFFs?=
 =?utf-8?B?SGJaTkQwZDgyeEhUVDVTUEM2SXhRbE1ZL1JBWUxWNkZtWG0yQmlVNHkwZXJJ?=
 =?utf-8?B?c1BpQ2JtbitoWUxTWFVuRG9TVEVhMDU0TXhldmFZZHFMMDNhQnQ2U09XR3pQ?=
 =?utf-8?B?UUVDMVFwckxNOWk3Qk1VNUpEN1hmYjNaQVBLNSsySjZIZHY1aW9aYzlUeXEx?=
 =?utf-8?B?T0FaVmNwZFM0ZDMyTUlmWnBVS1ZmQnFHYlB2N2ZrajU0NGNWU1htUy9zZWdx?=
 =?utf-8?B?NnJXSUVrOVhqM1k3QWZTOVdsRUhKQ1c0b0JrclZPUXI5blhoUy9QMmxTRm9N?=
 =?utf-8?B?cWdhRTRmSmNRNFV2ZWEzaHduRkhDV0hLQytzOW9ldE52YUdBdGZieVc0aTB2?=
 =?utf-8?B?MFh4Tit6UUJ2akgzQXJYQ0FwdkdzZGRienpkQXRxOTgyK1pYaUNRYlVNRlJM?=
 =?utf-8?B?dGVwbGpGSkl4aHFmTk1uUkF1ZlJiOGNMY2VueUUvL245ZkdYUGNnS3FFZXND?=
 =?utf-8?B?ZWQ3cVFCOG9Zbll2Zk5MeDdhSU9DSVJxM2ZuaUt1aGlyWGw0b3U2RHRGRmxJ?=
 =?utf-8?B?alc5dm41VVBaRURkZFhUSitiWUdyQmd2Z1FkSTZrZ3MvRzErT3BobW1SeUZD?=
 =?utf-8?B?WUlqdkNuVi9FNDgremJoUlA0eUozZ0gzVFBQNHVtSmxGZWVLMVJpaldVOEF4?=
 =?utf-8?B?RWFqNUNsQWl6NnhlMWVXNk85L1VYQk5oK1drZnJxZHpjdmNFMStFZ0ZrRWZ1?=
 =?utf-8?B?RW5UNjlaSy8wUEdrTkZPRGdlVDJRY1p5Vm02UXB5TGlHSU5mQlBNNUFsQWNq?=
 =?utf-8?B?cjRwOW83aURTLzRZQWF1V2JjbEVMdGlWQWJhK3hFOUI3b2RyRVdtVkhPaHRR?=
 =?utf-8?B?QjRiZzgyTnNaanc5TXJPMUxQRHBab1RPSDVLWFhmdFZjRXZubmxYQnJWQk5m?=
 =?utf-8?B?NlZ4b2RyN3V0d3N6anRTVXQ5dUJUeDl3eWQ1TFhHQytrV1hmOW1EbzFIbE01?=
 =?utf-8?Q?KhdoSmolu+BLaTYHjh1j8HXun?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b1d381-ff82-41d6-6744-08daa7ddc8ee
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 21:00:23.1242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ex0muKn/kumhAgOVzWSJv5iwNjKbAWOxyWm4eue6NglQOL6T6ESg4W6txm1Pw5jf1vyJXtU23C1FM9+8dlXx6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5803
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi All

We are working on measuring one core peak performance and have been
using the one-core-peak.sh script. While the script does what it needs
to do we find it a bit hard to use and not written in an ideal
fashion. We are planning to do a python version which can be done in a
much cleaner and more readable fashion.

Rather than stomping on toes and just sending a patch to replace this
script I wanted to solicit feedback from the original authors and
community that this is acceptable.

Cheers

Stephen
