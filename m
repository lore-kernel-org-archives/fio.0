Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C160C433F5
	for <fio@archiver.kernel.org>; Mon, 21 Feb 2022 14:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378114AbiBUOlQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Feb 2022 09:41:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiBUOlQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Feb 2022 09:41:16 -0500
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2090.outbound.protection.outlook.com [40.107.24.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E211205CF
        for <fio@vger.kernel.org>; Mon, 21 Feb 2022 06:40:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZcUYNAMf/6Q4WZrx72L1hVVU4Z62Qv5mzBICb/sswl7kyyQQQPr1kMkjWkfBhIW/Xr/6M3NoQk/KGx9DqWDewRpsMEGF/39ERBUAsF/314piDbPz5xKg1CA/bwAV81ImK8lRbBqzuCeGQhJ1qLRWyWd1pgUBPILwirFVc2z/KqDs5+sIiJBrZ8XQ/TwIzwvQiHLNPRSO8XxfKUx2lqViKq6X87jNtrMXJf7c8iFVffvXRS6wcmEWYP35M+i8NE7NOr3/K6c/3U4q9iclF5rjc0KWvDWS+wpErNXrGODcUsieoZl5lZxeXUh5an0TtJz3o5N+QdQJEB9cuOb+GzOsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJaaJjyZi0dQv33CAOJ1WS6q8Lu2kCSQt2XuEv6c/YU=;
 b=JKepHXjtzRMX7S2mSjomG+sVAEmNeBWj8J6n9KJ3hwxt8AOPz3zyiQoEpI5vmJ9/Rj8sEQZ8YRzdmErMfakI1A8KUldHkinLcNYmeodcxg4k38OrTqbO4cBSE7beU53DAw7va4WUi3F1NgOwxC5v8whHoCrI5Oo/ltFga2mo326wn+NhvKv9LM2O0Nugj6vuDsVihl8fH1T7t0m1j749Mb0X0P2+3Y7WzvJ7Jvf9ktNQj4+tbnnn8p2oKF3z0GkSPlIYU0WOW5H0yEV6U/+IytkBgq2oOZc7tCQFh5PkxlgvNMRevqElFXDeIj5qvL02NJDAnE9mI8Qd6swq2DqERw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJaaJjyZi0dQv33CAOJ1WS6q8Lu2kCSQt2XuEv6c/YU=;
 b=WUsN5mcZ96MtQyVp+d3Pz/L0BHz9YwiIKrLdMBbfkpRPTKwpDAYtaxUw54IUsc8aaRMO5rLtJGjGLg1OrIQpbsIFFwAgA2P1Hduu3Lwf6KahVnnt9Xxjcw6s75qxdm0QbegWqsGOlovqhJexW0fOIlXqkb38yzYsaNtnV4ZEmEg=
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZRAP278MB0414.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Mon, 21 Feb
 2022 14:40:49 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f9e8:b0bd:83a:346]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f9e8:b0bd:83a:346%3]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 14:40:49 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Using FIO on systems with <=512MB RAM
Thread-Topic: Using FIO on systems with <=512MB RAM
Thread-Index: AQHYJzEERcXvP3wQB0KCk0vhofz1/g==
Date:   Mon, 21 Feb 2022 14:40:49 +0000
Message-ID: <6307548088955e55007b6f8838d242e37e00a4e4.camel@toradex.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af110a48-1b62-4d03-5fcd-08d9f5482784
x-ms-traffictypediagnostic: ZRAP278MB0414:EE_
x-microsoft-antispam-prvs: <ZRAP278MB04141D8A340C7063F4D12906F43A9@ZRAP278MB0414.CHEP278.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PkCj0leg9N0z1j4MYuFMz8fcen7RmR5czh26iQ5Ju+pIX5BPN3p6RCZkB0pkV2v/3mxLxJ69HVoWYLHiC4VAo7CdMfYKtxt/Vdj9ovnvLFlAiqgNhprmnjR2VwtuyNS2jObMZSufGVi+EWOIybOKyUklmftrncBdtrQrtzOF1MC++xBtv19OxHeQimbNCrmRAAv2Q+TNjChLlteROuQGZcx2XWXgpfIxgSJA5hWoAFcOSpqfdBdQdrSNRB+8CMFxNw17ZBXq9KWeQzbaM/GxfD8TsNvbhr5HCpNb8NynsfE4zCPHO2krXVXvob/TMV2i6obSa6lChEPPa8cakbdowyLSnQJQF4kzQRxYYGY22lYrbYldZ8aVKrsvc14BE8x7oRCGZO7ct5inv3sGeN41TOuxM+gl/0Wpw/zBU734+7r9dzOqOGruXJ5v1X/5y3lgvzOrKNdiC1As5uFl8UpgjzjqPDGUvutIVk/w/ZUPJ4ohHL2HCwtLpFp/au+Ly26cI3l15pFAVzsN7dYfcGIrf1Mh9+ltW9nROJLXtmDFCwMoMIzqcLXME1N9fbT6Wb8brYyPaJyGwUY0ECoNFvwW8KSDfAjhHVbXfyAQGvgs4DxU1py866ze80O0wLWgqfbcGw5BPMeHFHPfUAfHiYrpV+Y+YSM+oRwf6GuHBcqzVWTnRwWs3TZryIzQFPDKwLVQglgw0MOMHSyrFPpCidavbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(508600001)(2906002)(6486002)(4744005)(8936002)(316002)(5660300002)(2616005)(44832011)(6916009)(86362001)(186003)(8676002)(36756003)(66556008)(66946007)(76116006)(6506007)(26005)(38070700005)(122000001)(71200400001)(66446008)(64756008)(66476007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWNZWDBtRmk3dDY2QVV4cG1hdnlxeEZpYmkxRHB4ZnJCd05FYzNYbUl6R1U0?=
 =?utf-8?B?Vk05cDJCVGxabGtYaFFpWWQ1WDFYSjRsQWN3clU1S1I4UE82ZG83YXNuWEUr?=
 =?utf-8?B?RVhiSGNKanVadWNDSnVpOC9HVnZsaXZSbCtWc29EMG5oSkp2TGJQcEY5QWRt?=
 =?utf-8?B?UFphcDAvZGtOVmhpZUpHdmlLcm5yKzhCUWdsc2ppNlVNL21uanhpUDViRmsw?=
 =?utf-8?B?YTlmRjJDeDA2d25iSGwxRWZHNFFidlpVWUZHYWI2UkhkSDZiRHdwVll6U1RW?=
 =?utf-8?B?emFVUjN4bm1mSUlNTHNWdVk4dE13WjBXYWx6WnYzZkRwK2xWSzd2WTJSNks3?=
 =?utf-8?B?WFlZSjZmaGtRRWQ5NE41aU4zOXpjaitOdVU5aEJ3b3lkRUdGN3hLKzRRWWNW?=
 =?utf-8?B?YXJqc2RpdVE1WFJzTlRDVEpYVjdleCtMMVpUR01VZ0MyeWZocU00NjBZK0JL?=
 =?utf-8?B?SkJURm9UZ2o1SnJQTWh0bnluQ2JPbWQ3UTFzT2lJUTQzNEJGZDhteDNpVHM3?=
 =?utf-8?B?T3o3VGRGSnVNejFVcUlLYTFjVU5IR3JBOTZKMkdHYmllY3d2L29zSSt2cDRT?=
 =?utf-8?B?a3JkVmkvZWFJdHk3blBGRWZUd24ySTBQcmNQME1TRlRodmR1ZjM3c1I0b2s2?=
 =?utf-8?B?TmlQeWdOU2pwNXIrUm1aaER6T29Tek5ISldDQ25BcVllcE1mQ1FFMWc0dENy?=
 =?utf-8?B?OTlEd1N6S3B2OXE2MDRkY1FkcHgxc0tRNE1KcUdSbUQxSnFNZ1VQWXZ1dGJZ?=
 =?utf-8?B?MTJHUVJ6VWdjQzlTSllaeUpOVVQxcGJNL05mcjZwam51cjNQb1NFTmZrYmkw?=
 =?utf-8?B?VjNRRGkzVDlPVTRZRUx5b0J1Q3FtallRRGJWcEtGeEZRTm80V3oyMjVIbnQz?=
 =?utf-8?B?eUFoSExBK0pZVzR2K3J2dVl0RUdEVzUyeTNxcmgyak9nOWtiN0phWXhuQjI1?=
 =?utf-8?B?ajZ4TG9jRVYxLzN5SlQxS0E3bjJDc2laM3VWdEJicVJZdndvV1dUU3RJQlVD?=
 =?utf-8?B?SUxGalJJSFY4T3dwSlkyc0NpODFzN1paNCtuZ0FFdUY2WHRWZzNUL25abG1M?=
 =?utf-8?B?N3FwakZzdHdSZDZXTWVlQUo0dmVsZFprVUdGdWVQKzRpTlZERW1MUHR0cWtX?=
 =?utf-8?B?UnR4czRFQWpNYVBBVm1mNjBzUnY3VGdwMXpkOC8xeU5sQlJzNlcvZFlqUUUx?=
 =?utf-8?B?Vm5wM2pxRklIYnk1MGNpTWVJZTBTZTJsa3V3RjJtTlhSREJrRk8xejlmb0x0?=
 =?utf-8?B?SnFwenozWGZ5aGdqMHlENVJGYjFPYS90cXg0U3VXV1ZnK0M1OGdLNm5JeFFS?=
 =?utf-8?B?djRJRkM1SDZiZlFhd3I2VS9adW55TGFQanJKTG5FMXNBb1JoblB1Ry8zWFZF?=
 =?utf-8?B?QzF2bXVFZXlQOTF1Q013QUNhL2NqMG9UaE9xRFJaeTVYNkRReXI2QTIwWUMv?=
 =?utf-8?B?MzFuUHRvT2Y0UUVRV1dMRi83alJnNEtyWFZjTHAxNXdHZ0ppQ3pyVmgzOHhh?=
 =?utf-8?B?YXhEd21qRXNHQ1JueFRmNTl3N2VMN0tnR2ZwSFhZa0c2UHpua3J5RDlIOFU3?=
 =?utf-8?B?THMxUU95RUo2Qm5abUZhMk80cjR5TGFBcmZBSTN2V3gxdGRVaEdtNXhCY09P?=
 =?utf-8?B?VkpYZm03K01PSVZLSCtkalRmS1pqS25rNzBjbStQTWRobTJkdEQrbVRkc1RV?=
 =?utf-8?B?YnJHWk41dStvL2pqVTVwT05hWXI5R1BobWgvUm9WcjlZWVRmTlVLNW8vdCtE?=
 =?utf-8?B?bXYyNGpYN3JHd3E4cFhnUThiR3ZtYWJRempWY3QwcjV0V3VGakRkQytXU2tF?=
 =?utf-8?B?Yms2clhFMWNOR25ubTZvRWVyeEd0cloxZVlGY3loRnJrR2pzL21FdkZncjZL?=
 =?utf-8?B?bWZjbFd1NTJkeDlIM01ZdEJkZzQzU1JDRS9tK0p2MWZnaGNmS3Z2Wmx0U0tu?=
 =?utf-8?B?NTNTKy82SWVDWGFhN3JpZDJPTmtuMHUvRXBYSjJqYXJ2ZFk1UWg4WnpOSUoz?=
 =?utf-8?B?ODF3c05zazBybDkrNUo4ZksrNjgvRHFycEhCQTdkUzY0UFg1dFJ3RXRTVHRS?=
 =?utf-8?B?eFM4N0pjY1pjbGFmMnkyRUQ5MUpUVko5cWRUUVJ5WDF1REkxOHN0RlFxQi9L?=
 =?utf-8?B?OG1WV0FWc1VsUGVLMFJWT085N1lIRVNyckNodmVUZTJ4RmQreHBSS0hVZXNS?=
 =?utf-8?B?WTJoVkJGT3dPNXVjbkJIVmFoQm9jMTR3VWtXVkZLcloyRUlCSUVwQnk3UzBa?=
 =?utf-8?Q?3nM88TfGEt8m/fMt34+Nz7pvYTltRz2gmE76gTyPb4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0B6E08F7340A24E991A21DAEC958868@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: af110a48-1b62-4d03-5fcd-08d9f5482784
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 14:40:49.8291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oQPC1IVpjYhrGLJJK9WMiFCsnpn/nInXoIrh5a5YcZ/cfTn1GwwNoNrG8+lt5tI2aDW0qdNmm8XUetudjhjccU+xSwpVkNx29M2Eur8Edes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0414
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

SGVsbG8NCg0KV2UgdXNlIEZJTyB0byBjaGVjayB0aGUgZU1NQyBzdG9yYWdlIG9uIG91ciBlbWJl
ZGRlZCBib2FyZHMuIFRoaXMgd29ya3MNCmdyZWF0IGZvciBvdXIgbW9kdWxlcyB0aGF0IGhhdmUg
Pj0gMUdCIFJBTSBidXQgb24gYWxsIGxvd2VyLW1lbW9yeSBvbmVzDQooPD0gNTEyTUIpIHRoZSBP
T00ga2lsbGVyIGFsd2F5cyBraWxscyBGSU8uDQoNCkkgY2FuIGhvb2sgdXAgYSBzd2FwIHdoaWNo
IGhlbHBzIGJ1dCBpcyBqdXN0IHBhaW5mdWxseSBzbG93Lg0KDQpJIHBsYXllZCB3aXRoIHRoZSBz
ZXR0aW5ncyBtZW0sIGJzLCBpb2RlcHRoIGFuZCBzaXplIGJ1dCBjYW5ub3QgYWNoaWV2ZQ0KYSBj
b25maWd1cmF0aW9uIHRoYXQgd29ya3Mgb24gbG93LW1lbW9yeSBlbWJlZGRlZCBzeXN0ZW1zLg0K
DQpDYW4gYW55b25lIGd1aWRlIG1lIGhvdyBJIGNhbiBtYWtlIHRoaXMgd29yaz8NCg0KQmVzdCBS
ZWdhcmRzLA0KUGhpbGlwcGUNCg0K
