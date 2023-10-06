Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0AFE94114
	for <fio@archiver.kernel.org>; Fri,  6 Oct 2023 20:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbjJFUTQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 6 Oct 2023 16:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbjJFUTP (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Oct 2023 16:19:15 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0AC11D
        for <fio@vger.kernel.org>; Fri,  6 Oct 2023 13:18:49 -0700 (PDT)
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 396IibXe010873;
        Fri, 6 Oct 2023 20:18:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=nNT7ShK4Dzwe8Mb5EyldxLyVnXhA4m377ub+AlMuPyg=;
 b=eO8HryoPJ4kr5cA515XO7PaDR62tRHpf98qBjfXuAv6jBsntrsJ44hGE8a8JW4apJz5J
 +cR5uXCyP1XRamP/TcYmJ6HU+50Rb5WoIF+ObxLj5tQs/ie1ibQgPKh1W2lYOnQ2SZ6s
 yeMqhHMKpm1DGZd+W2vYi0Ha/1Pxyk5a9RphPWF+jGDIHWOgHgYNiWG5+F3n6foqHV+v
 crWv/ySooOREqH3fp1izY7jJN7wpc8Z4TWGnj7kx95DMhoV/gnX3Z6XNZ+zbuCatG3m9
 2yA4dl5KOfc+tcLhRIvxsntaYTPJ9A1WX9SA0ApeHvqnzIjriR75Ai2KOf9K725tVfpg bQ== 
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3tjfspn3g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Oct 2023 20:18:48 +0000
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 91599805E56;
        Fri,  6 Oct 2023 20:18:47 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Fri, 6 Oct 2023 08:18:43 -1200
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Fri, 6 Oct 2023 08:18:43 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Fri, 6 Oct 2023 08:18:42 -1200
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Fri, 6 Oct 2023 20:18:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bO1KLvzV8TCqAXcUxXv8AsDxyfbi9/BkGi4ejxbDHQtNHBCd0wJQM/lwepVqvb22K1Z++Ul9Sp4O8GR76k9vlxBkw+SGE8tmzxgosP+Au6k41i6+EAlehLH8/KaU0rbdUUUjgPCeV7dwz/P+6nkuzVuPQaioTO3AwQmuRsRbKT/Jzai+RG8Bbenyj/82Mt9xCi49ag/dnB0HAUlcn88QulwjUzO/uqn7sWzK6wnrOs7MV5CIyHNHNgjEabFG/QaqOimx1v+wkFeqOpiW6b6DwJkR6WiyrUpSSgtZMVOR3kxl6qQsiOuMR8hW3axgfjBe6MiiL2QwYq6+sbD/V8eOAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nNT7ShK4Dzwe8Mb5EyldxLyVnXhA4m377ub+AlMuPyg=;
 b=TNXlLiNZJWlKJ6L7Jw6X8rsC1oTQd7keIoc59qFfK8fzr5RdVM2znj95k6weJwC+Xa/qzO/fsrbzYwP4D6G7XZoPW0mDdYw5T0o39OYJHnI0AlfS5WDyKfMhzRpYJ/dYYxj/y9onkO0Jo4X54FEo/5xeuMuANbc8ijRlap3U513eNJS05OQjz3iwHe8xtKXXmRaj7YuU1+FAv5dVpYQotzt2gQ9MHsiClx9nrJZNW00G44D6R3n9bsns2WV8FBsKoYYJuORXxAd5H6or4SOQtS8Y8d5UywSCOjGqIu2A/8+KfA54qK93X6F0GouAVYM5hLZbCfGYe9PVs9fhpyU6Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW4PR84MB1851.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::16)
 by SJ0PR84MB3199.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:47e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25; Fri, 6 Oct
 2023 20:18:40 +0000
Received: from MW4PR84MB1851.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::7598:13b3:cdc3:c6ca]) by MW4PR84MB1851.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::7598:13b3:cdc3:c6ca%5]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 20:18:40 +0000
From:   "Wolford, Jeff (CBG Servers and Options Engineering)" 
        <jeff.wolford@hpe.com>
To:     Matthew Eaton <m.eaton82@gmail.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: trim entries leaked?
Thread-Topic: trim entries leaked?
Thread-Index: AQHZ+I7LZT11IQ+R1k2ajRotvGF2B7A9Msyw
Date:   Fri, 6 Oct 2023 20:18:40 +0000
Message-ID: <MW4PR84MB1851339BB56E7A41B8B1F59F82C9A@MW4PR84MB1851.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAF+0mvm8bw-wvnSv8SUm=6f+T+zSMd-uXm2weefGyONqL+qq=g@mail.gmail.com>
In-Reply-To: <CAF+0mvm8bw-wvnSv8SUm=6f+T+zSMd-uXm2weefGyONqL+qq=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR84MB1851:EE_|SJ0PR84MB3199:EE_
x-ms-office365-filtering-correlation-id: 2e39b6df-cde3-4add-8e36-08dbc6a96e5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DsAHVcP8DwJXsIQGPt9iYAEEWMlfGTnSOjZuB37dzw0p0mK0bkBr5fFVgGMx0vP8qQw+rsaU82wPNlW3E/hTCeGlVSSbrHJdVatgqy+7Hpgpz4v11m3mtx51B9wZYCa+sGlyXhOqdk9zoQXD9WM88Y9fZoeMObQptBg2YBeJ/trLACg9DjOtd49TigW0OEXv5nF3J2oHWn9Hv+HM0WFbxvPNBj+OulQP9Iz0uTQPdgWK+TV5dxdRTZkB/9OYLeP6ZQn3/IkahHk9hQRVEPFv+yahK57ZCCJnTl4+jwkkfI/j1KQSTYoZKVCTN69mkW/8YQSY4O3YwsRVCOS6NzpPdv4oUiWh3FjHDR+mGKslTpjvkkU0cMYVc7cUDCqhmzo9+tMu1eazXACqqnNcqLL1T0o3+NB6LS7WsTHZmGKtpGr0fqj6M3wVLWupJIvOkZGMXzHmxKjkZmREatW8NxKB3yPh2pWoESmV062J+P2nfENCOYzNmiC/jGVtDoYVSLyDteGPUfpFztfTkB6CGV5n8svWpkevI9QlZchD4UfRaSZdvTFBiQF1rA77g+eeWdbQT2PE+m+CDAUMzw3cMw/nu3m1mV9HFC2hzg9bUb7uI8psnRlCJIMaZlQOG2InLHd5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR84MB1851.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(346002)(366004)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(8936002)(64756008)(66476007)(8676002)(3480700007)(76116006)(5660300002)(66946007)(41300700001)(478600001)(66556008)(7116003)(55236004)(83380400001)(26005)(66446008)(52536014)(9686003)(316002)(7696005)(122000001)(38100700002)(82960400001)(53546011)(38070700005)(33656002)(86362001)(71200400001)(110136005)(40140700001)(6506007)(66899024)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tkt3cW5pUEh1d2FHUWptUXYxTG9xRHVTNXJEU25vRkI0VUxiNlFEMUgwU0xl?=
 =?utf-8?B?QXUzMEJHQk9VczR0RTVvamcvRmZCQVBHZ0NvZVVmQmUvK0pCMGVZLzl2YnFF?=
 =?utf-8?B?VXdXWUM2UEIyRS9Yc3NiNjRWNVZzSTkzUU1NcUU0NVhlSVRsWkJIaVIxazNN?=
 =?utf-8?B?dHMvMWY5MkE2WnUzQjdUYTR3UkVJMTRkUUZUM2dtZHNXRVZYRkNyYTBtYUdQ?=
 =?utf-8?B?VjdtVDVoQXluZHBLRkNNV2NMV2h5YldmRGNpWXVqS1E2LzJVdFc2ZGpZQXNq?=
 =?utf-8?B?T3lta2xqV2FRejZObzRGanlHL2ZDUlAxRGh5VTk3ZFQxQVdjalBwLzg4eVNu?=
 =?utf-8?B?K1c1L0NUQ0l1UFROV1lWTTlEbWdMUC9MRVR4SU1OWWRBT2hNWVFQa3k5eHNl?=
 =?utf-8?B?NElqMU02cjhydjBLcjh4aXlDK0dWeUNqU3UxVTVydDhMWURqeHJVVnBwcm45?=
 =?utf-8?B?M0N5Mm4zcjJpWFA4bFNzTUdGZzE5alI1dFBDV1YyNkh3RkF3SDduV3F2Zldp?=
 =?utf-8?B?UGs1VmFFUVBSQnpMdWgrWkRuK1ZZRnFhV21YT1BNNWlmZm81c0VZSnFnU0Zy?=
 =?utf-8?B?Q3NMUS96eFRYTTFnZDJlazhRTHVvMVZCbmVxdTZLRjBkdmVjazdWcmhtS3dz?=
 =?utf-8?B?b2h1V0FtYURGbnF5MWlWUldjUDVvMGRJbWRoMlpZMXlvZDEvZngrU09QdytD?=
 =?utf-8?B?TDBlSDZmMlFGbk52MkNSbHg2c1NNWUF6bUFDVXlUL2twM0tvRFdRamkrdlR3?=
 =?utf-8?B?TXJNM1NDN0xvV0YxSm56dWFTYm9qZGhHZFdPWE0xdUNuUE5Ha21CMW0rRDZz?=
 =?utf-8?B?a1RvamVjUVVQYUpBSERFUGJRZkNOdDhTK0RoNG5kTTZoZXdhKzJObTJaN2JM?=
 =?utf-8?B?N3YxZkg2QlIzUlc4cVZDYm5GT1R6WnJpeU1aMlFIQy9EbzdkTTlORTBuYVhC?=
 =?utf-8?B?T24vVjBka255Z1F3K3pETHdHNzJ0SXZWRWhCc1BpcHkyaWN2cHkwYlZOakpB?=
 =?utf-8?B?WUNlTiswdWNHQW9Id0dDU29GR3dqN2FkZzZjTDc5WldrZGkwT0U4cndEMkNE?=
 =?utf-8?B?c29EQkt1cXVid0hzemxTTXR1aEJkM05oYXR6M1lrdUxpeEU1ck9KRkdydzFw?=
 =?utf-8?B?amtvdzQwRzRJMjA0TFh3MXQ5Qi9GU05pMWRmRFZtekNaZzdqU09uWGg1bGNl?=
 =?utf-8?B?bFQvbHlWazhtK1dRUTk3dWpCdExVcmdXa2IyWmx5ZkhHQ255ajhCR2RJcWpD?=
 =?utf-8?B?MnZyRHNMazFjS3gzYUNuN0V1V2g3VzJscUxKZnQycy9TQ1FZVVRqSmgrR24y?=
 =?utf-8?B?RTMwTStaK1pBTnhEdFdjZjhzcmU4U3FmTDNBbXQ4Y3BMNUE5ODNKa3dRSU5k?=
 =?utf-8?B?RjJBSFg3Zm1ER0FhUUNRbVdhUDgvOEdBUi83MDloYnJMdktzcmVSRE1FUjFi?=
 =?utf-8?B?bmlMUDQrUkJscVBZU2dBTU5saGlFRERHUjJpalZ0RDFVaVBpRS81bnhoQU04?=
 =?utf-8?B?NGdIMXozcCtUREVZQkJlYTVlcGtsWFhUSzBrSjFUd3RqT2ZWK0tIbEtkbmlV?=
 =?utf-8?B?RGptc0xQV2dublNyRWdheGdBZHlobFFFTVBlaXU5ckkvaFU3RTUvamxYZTYz?=
 =?utf-8?B?ZkN1VTY0dkZWT3dVaSs2Y2QrRTViRm9Fak9xUVVJSFhGUFIrdGZFOHlMbFpG?=
 =?utf-8?B?b1hsUms3UGxpYnprZ2dFV1MzUHJBQUp1T2doNmMwL01sREZoM0ZvbEVBdzNj?=
 =?utf-8?B?RGNKeU4rRDRrS09JSFNxZGgwWTZsSjZaRC94UWUyeDB0Y2djODFLZ0RkbUJN?=
 =?utf-8?B?VlZyN1hzZG9PMXRlZDJTOS9xbFg1Y0FHNndNYW5IZVRNRlBjOUZTdE9BTGYv?=
 =?utf-8?B?ZkZxWTFFUEhQUkVMdThCY2VSYlhYN3N2UitKZ3pNRFpHNVBGVWhsOVM2RFRH?=
 =?utf-8?B?TVBKZGhlcWZSWkpFOVh2b0M3TXg0ejlyb3NOdy8veVg4S0EzNXBIMGVvZHMr?=
 =?utf-8?B?OUlzaXcxK0RZTEZSSlJjbzFyOEh5UUlyY0ltVGRhZmlnaE1VQVo4VWdoTDhE?=
 =?utf-8?B?d09FS25xbG93ajFNam5LUm90b1NIa2FkM2ZTamViUzlpdHVnWnY0MEtSU2F6?=
 =?utf-8?Q?ie8l/tWRl2zPOnP/SIJGj5iR5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR84MB1851.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e39b6df-cde3-4add-8e36-08dbc6a96e5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2023 20:18:40.6308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mSJxEUZSYGZ3Ov4vuf0kbLoxgjKZBFicR9paNVibCDUg0CwA1qXgorEclNXTsjUMv62/DqNkI56VHo4R8IRD9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB3199
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: Oj2y9-0o_RzjY9poJrHickd_tXPed47w
X-Proofpoint-GUID: Oj2y9-0o_RzjY9poJrHickd_tXPed47w
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-06_15,2023-10-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310060155
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

UmVtZW1iZXIgdHJpbXMgYXJlIG9wdGlvbmFsbHkgcGVyZm9ybWVkIGJ5IHRoZSBkcml2ZSBhbmQg
dGhlIGRyaXZlIGF0IGFueSBnaXZlbiB0aW1lIGNhbiBhY2NlcHQgdGhlIHRyaW0gYW5kIHRocm93
IHRoZSBjb21tYW5kIGF3YXkgYW5kIHRoZSBvcmlnaW5hbCBkYXRhIHN0YXlzLg0KDQpJZiB0aGUg
b3JpZ2luYWwgZGF0YSBpcyB0cmltbWVkLCB0aGVuIGRhdGEgcGF0dGVybiByZXF1aXJlbWVudHMg
Y29tZSBpbnRvIHBsYXkgKGkuZS4gemVyb3MsIGV0Yy4pDQoNCkplZmYNCsKgDQpKZWZmIFdvbGZv
cmTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBFbWFpbDogSmVm
Zi5Xb2xmb3JkQGhwZS5jb20NCkRpc3Rpbmd1aXNoZWQgVGVjaG5vbG9naXN0DQpIUEUgU2VydmVy
cw0KwqDCoMKgIFRlYW1zOiAoODMyKSA1MDItNTc0OQ0KSGV3bGV0dCBQYWNrYXJkIEVudGVycHJp
c2UNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IE1hdHRoZXcgRWF0b24gPG0u
ZWF0b244MkBnbWFpbC5jb20+IA0KU2VudDogRnJpZGF5LCBPY3RvYmVyIDYsIDIwMjMgMjo1MyBQ
TQ0KVG86IGZpb0B2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IHRyaW0gZW50cmllcyBsZWFrZWQ/
DQoNCkhpIGZpbyBncm91cCwNCg0KSSdtIHRyeWluZyB0byBnZXQgYSB3b3JrbG9hZCBkb2luZyBj
b25jdXJyZW50IHdyaXRlcywgdmVyaWZpZXMsIGFuZC9vciB0cmltcy4gSSd2ZSBuYXJyb3dlZCBk
b3duIG15IGpvYiBmaWxlIHRvIHRoaXM6DQoNClt2ZXJpZnldDQppb2VuZ2luZT1wc3luYw0KZGly
ZWN0PTENCnNpemU9NWcNCmJzPTRrDQpydz1yYW5kd3JpdGUNCm51bWpvYnM9MQ0KaW9kZXB0aD0x
DQp2ZXJpZnk9Y3JjMzJjDQp2ZXJpZnlfYmFja2xvZz0xDQp0cmltX3BlcmNlbnRhZ2U9NTANCnRy
aW1fYmFja2xvZz0xDQpmaWxlbmFtZT0vZGV2L252bWUwbjENCg0KV2l0aCB0aGlzIGpvYiB3cml0
ZXMgYXJlIHJlYWQvdmVyaWZpZWQgYnV0IHRoZXJlIGFyZSBubyB0cmltcy4gSWYgSSBzZXQgYmFj
a2xvZ3MgdG8gMCBJIGdldCB0aGlzIG1lc3NhZ2UgYmVmb3JlIHRoZSB2ZXJpZmljYXRpb24gcGhh
c2U6DQoNCmZpbzogNjU0OTgxIHRyaW0gZW50cmllcyBsZWFrZWQ/DQoNCkknbSB1c2luZyB0aGUg
bGF0ZXN0IGZpbyBhcyBvZiB0b2RheSwgZmlvLTMuMzUtMTM0LWc2ZjljLg0K
