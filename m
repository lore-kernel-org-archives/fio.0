Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6390CC61DA4
	for <fio@archiver.kernel.org>; Sun, 19 Feb 2023 17:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjBSRce (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 19 Feb 2023 12:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjBSRcd (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 19 Feb 2023 12:32:33 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2072.outbound.protection.outlook.com [40.92.22.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5237C12F28
        for <fio@vger.kernel.org>; Sun, 19 Feb 2023 09:32:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKSIKc26g7zXf1Pvhr8SCUeKRad2ZMQrFURIYDwZ9F0Wa73sBPijEM4GuZzbWm8KTICb/4YRY+wzd847tm4fFfVJQ/1D9l0ou7J70UFg+V+JlGWSK3ozeYdQM/SoTUG0BwYLllJQwNQ8PEYhmsjMx/9RuMl6xu26kLz5WZrvKK4w81ICPz9+a0V27tnqW8uyws3q+KepKGnqEl+7XWVDZuKOq3G9B2BxoNc1kRe/u4DpvPiQAglalbjZmepFTgAOsk82K1AGHhU2MVtS0yplOsYMslprImDhjPj0VNXupWH570inBn5BO6e9i/yziYsrQB494tysO5Cg4c9sSv6duA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=er7uolCiP01sxxOcpanOTpKwC03eQ6WV5XI6lfEJnuQ=;
 b=LHivP2uzGd0dEWl2a4MPckQS8sDns0k8bIZwg7if7O2rkW/TngX8hiiraW0nMrAuPMCrTPkndmEfAECj2qFRoJXohOMpJ8dYaTPDOCy7Brrgpr2eScchzf2c4yflNkpzKuApMEMaMmiWuiPM7SQz4e2pKKWzS6IYfsfUeCMi1IYrw0IbZjro6xAStLVdXVyslhskc/cr2c9pEHiFYHv0z8GPe0uvcBXQoBlYouvKZfy//F6Ab/dXJg9OL0N6lwfaguJCqflGZ0K01+w9+Mbe+75+5B9ey2kURaD5Cdjfsl2ldEPI27cRJIujy41SdtXrTDhjs00buaFOLRm25ZiS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=er7uolCiP01sxxOcpanOTpKwC03eQ6WV5XI6lfEJnuQ=;
 b=PPspC2XlYYIlYms+Qjnxe8u47KpsWfbLdYHABVNN4RNUkRIXUol/KdnW46vxLfqn1wvd01HeWEur/vZxxkkEiKYmY7s4v/V9h/I2S3XQMaMe2aCvUpQccpF9iI8Ic1e/EpOtgutLzHTP7VJ5vMDYwoNdQ9Vind+cHYFofg0Aahq4D7LXeYCqheDFQiit+3Vz/8bDQ+uEyjd5QzX1OTG+losIop3D7glePlb7nlcjChdU/KeLMg6Dd8D7ldGNGBxCYRCBWGHOl70isFwLjn8OTEfIBN8hoXKA6J2riV+WO/xvudTqSozTQFbsSV3tqRKXVakSKb/zdO6hzcH0A0ZQaA==
Received: from IA0PR17MB6275.namprd17.prod.outlook.com (2603:10b6:208:43b::7)
 by DM4PR17MB6938.namprd17.prod.outlook.com (2603:10b6:8:183::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Sun, 19 Feb
 2023 17:32:29 +0000
Received: from IA0PR17MB6275.namprd17.prod.outlook.com
 ([fe80::854b:a77e:3ec2:ac0d]) by IA0PR17MB6275.namprd17.prod.outlook.com
 ([fe80::854b:a77e:3ec2:ac0d%8]) with mapi id 15.20.6111.019; Sun, 19 Feb 2023
 17:32:29 +0000
From:   Adam Horshack <horshack@live.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: Problems with interpreting FIO output
Thread-Topic: Problems with interpreting FIO output
Thread-Index: AQHZRCT1PRztfco5cUCReGrURH7j767WYuAc
Date:   Sun, 19 Feb 2023 17:32:29 +0000
Message-ID: <IA0PR17MB62759977BBEDE6BB9F718115A4A79@IA0PR17MB6275.namprd17.prod.outlook.com>
References: <CAMtsHkrJbk8GCrAvfAzKAASYOkaudNX0--mdnWHQ=nnAzhnH0w@mail.gmail.com>
In-Reply-To: <CAMtsHkrJbk8GCrAvfAzKAASYOkaudNX0--mdnWHQ=nnAzhnH0w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [envxsFj9dUov0u32a2OoccH+rLSALoG9]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR17MB6275:EE_|DM4PR17MB6938:EE_
x-ms-office365-filtering-correlation-id: 2f146ac9-bca4-41ac-1269-08db129f4686
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uGVUIJsNSichUVhvYfJ42s0SsvKq94YaPyFkg+9dKr3h7gYIVL8aNM9YhZmGH5IweD28QVOHCXxZoEfJEfCtUJjjvSgbLQD9QcFKljQTc2zNdVb3DSbSY35PI+sQpsmACJws2tMNe//MxTfSyVYSNIttoQXtupVAZUXmE3kE5ITN4Wub0+bCWX18MTyiHTPxDcbKSNjF2yWzZ86AC6ddrOPDmLkostWw++LtKjm8NKn32s4bCd0V3nrDa0SkKg7z8wPi7bq9okVKtZM22Ev17QoUKz9zCsKhiBRZIZMXidcRR+3tjFG7hKB/Bn04We/3QXIIDq0LX6zFqvSekvUUbzAdcIic/uggVY5mZzp4lG1VNBckdu3bnY8F7F/8TDV6aLNIDEhjLIL+O8irTGw24Jfbn/WewR9I4NewE1QHGKRAjTZhh/beiCzc5uB4kn7qTcNuFpFJhPBKwluNwlkagBEQIGGbbTfnETpLfYkI87McZyDN2jDJZ9Xzvl5H+yKNgdkODZSTGdITYoWNPYWK09Ewoztq1R4GwiVJduj80Q4VOSbo54HnMJHWk6VSVflvuJcuLiLP/Hp05GnTw177veWhUV0YHcD6p+GKjnZGEAH18TxDf1DxlTrbA5sMtzg9acZT0t44pKVCe+Oc7EZRO6ZTb1e6vQwM4t51cBb8/P0=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+8oSiqoWVIaMxreEaDSFWGE4IiBSE6KTjdZkM+djwo6JSKgOEgu+CRnANx?=
 =?iso-8859-1?Q?OUGYC05fYdTWeXHbf1rjDofrLyfU0reZjZoF3ERHRwHgcGjc8DYICMu2Yo?=
 =?iso-8859-1?Q?cmbY6HipRKkM8hkIM2qG3BTL5YIl0cIteBoz1xUrPJ99QDvCxAXicNzQko?=
 =?iso-8859-1?Q?1WP4Si79gbw3AJx9SPCPG3kLKj3/HBx9hanB0QV04sGJyKFJ4r4fW0gAs/?=
 =?iso-8859-1?Q?bW/GbPfX4r24qlNRTFfuq1OQhTW5kS2zRdfZg/NmZirYI9Zv4+P5qSFDZj?=
 =?iso-8859-1?Q?/auPFGOYpO9VIoyCLOynyQEdkWfg9X03TEZ4BP6xOYQWdhxDWdLgW6R/oR?=
 =?iso-8859-1?Q?3J6+hphxDHpflxLhcXcNAjAhW5nrjlPlM3OZKlfAr5LXp6XcsaVN0wVHXh?=
 =?iso-8859-1?Q?LAW8DLutf8NZuOJdG5iSKWIYlDVY2hsArpONfbSK6p6ospwvir6aFnOtbQ?=
 =?iso-8859-1?Q?0yR+nTQqdHBcOQKI/kq3tTb8ysQQrolnT/5ZuOvLoW0IoQQb5v2bu/GZMa?=
 =?iso-8859-1?Q?Fkb573SBqzCW/1z+eRwKyDmC9euOAAfjQLWLIi7cFhxNPi6DgcS/sW1+Xe?=
 =?iso-8859-1?Q?n+OBAObhYOOlBrYUBnrcrNSmd4Ba+U7RWhFK2klpt8aqZvvNT7xIMLamNN?=
 =?iso-8859-1?Q?hISMXP86yDF6IWmsmAIv6PAAgQsMwLoZ6giQ0lTqDfpItH9r/0L2hQKvhq?=
 =?iso-8859-1?Q?uSzHvtYaoK9a5ypji/dsiFhrjDCAsgFH9JkBo0KJ66yLDHcDS6uq8Fu/+j?=
 =?iso-8859-1?Q?aKxBRY4/lYgJ4IhHP50iQtyz7WVEC+Os8EDVYfCMn3/DdpF+mrm4UUDxSG?=
 =?iso-8859-1?Q?+6fOykY9ISaRI4qOXNr8YP+BplYQC8LNqe/lFv4usMVh85sDX1t2t88ySM?=
 =?iso-8859-1?Q?+sDtqObvVnAQjEyEVsB3/C3IcakO6cU6WXRKWxWszYM0rEQ6A2ictGaELx?=
 =?iso-8859-1?Q?oImcDRjCz7Cz5Op9VdNKU1SgDK0AuO+TlyEjeBdE0DaKL0BBVGGTMm0bde?=
 =?iso-8859-1?Q?N8WWi/sq2FQVGfGt3PSGHhJDeJ4qH4cHPB7oQXiJY8M2nGFsCdtcRNLuKV?=
 =?iso-8859-1?Q?e+UpOZiFd15rvCZW5NlzzJXjl+579TSRUypvOELLa/frAjL7sVciJbNZKw?=
 =?iso-8859-1?Q?20UvCRxwWeIqBH+v0lGw5kc6ReZl5CaiQQM1a3PXBFFIfhMPEaYHnp9Uap?=
 =?iso-8859-1?Q?NfXvvAG+aAHvYV+s9g7rD0Cv0M0AzIb3GEJmvvRMnsFAYyuml9fHGgZpZ9?=
 =?iso-8859-1?Q?cpQQbjo98S0qHDxG1uF7LM/7Nb9cHvmDmpGttluDoSmfUPuYA9xXehXojm?=
 =?iso-8859-1?Q?pauz?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-c704e.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR17MB6275.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f146ac9-bca4-41ac-1269-08db129f4686
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2023 17:32:29.4723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR17MB6938
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Seyed,=0A=
=0A=
As you probably know, IOPS represents total #I/Os / total time and iops rep=
resents the per-interval averages. The default averaging interval for IOPs =
is 500ms (--iopsavgtime=3D500).=0A=
=0A=
fio is reporting 12,469 interval samples for your run. I would expect 400 (=
jobs) x 31.279 (actual runtime secs) x 2 (samples per second, ie 1000/500) =
=3D 25,023 interval samples. It's not unusual for total # samples to depart=
 vs expected under heavy loads. Your reported IOPS is 2x your iops (199K vs=
 397k for reads), implying the #samples discrepancy is related to the IOPs =
discrepancy.=0A=
=0A=
I was able to reproduce your IOPs vs iops discrepancy on a ramdisk using 10=
0 vs 1,000 jobs. Read IOPs for 5 second run:=0A=
=0A=
100 jobs: #samples=3D910 vs #expected=3D1,000, IOPS=3D84.3k vs iops=3D83.4k=
=0A=
1000 jobs: #samples=3D1,470 vs #expected=3D10,000, IOPS=3D107k vs iops=3D17=
2k=0A=
=0A=
If I enable IOPs logging with a 500ms interval (--write_iops_log and --log_=
avg_msec=3D500) I get the following samples for one of the jobs:=0A=
=0A=
100 job run=0A=
563, 717, 0, 0, 0=0A=
1062, 759, 0, 0, 0=0A=
1562, 784, 0, 0, 0=0A=
2062, 772, 0, 0, 0=0A=
2562, 774, 0, 0, 0=0A=
3062, 769, 0, 0, 0=0A=
3563, 778, 0, 0, 0=0A=
4064, 706, 0, 0, 0=0A=
4563, 757, 0, 0, 0=0A=
=0A=
1000 job run:=0A=
892, 128, 0, 0, 0=0A=
2660, 95, 0, 0, 0=0A=
=0A=
First column is elapsed time ms, second is average IOPs over that interval.=
 Notice the 1,000 job run has fewer samples. Some jobs in the 1,000 job run=
 have zero samples. The IOPS vs iops discrepancy is likely sampling error f=
rom insufficient samples captured due to CPU load. I'm not too familiar wit=
h the back-end stats capture but I think it runs as a single thread. Perhap=
s its priority could be boosted.=0A=
=0A=
Adam=0A=
=0A=
From: seyed mohammad <seymad.f1@gmail.com>=0A=
Sent: Sunday, February 19, 2023 12:42 AM=0A=
To: fio@vger.kernel.org <fio@vger.kernel.org>=0A=
Subject: Problems with interpreting FIO output =0A=
=A0=0A=
I've run a random read/write FIO test with 400 jobs to benchmark a=0A=
RAID setup. The output IOPS and the iops statistics (the average/avg)=0A=
are divergent; how can this be interpreted? Should these two values=0A=
converge?=0A=
=0A=
Test results for read:=0A=
job1: (groupid=3D0, jobs=3D400): err=3D 0: pid=3D25204:=0A=
=A0 read: IOPS=3D199k, BW=3D778MiB/s (816MB/s)(23.8GiB/31279msec)=0A=
=A0=A0=A0 slat (usec): min=3D3, max=3D1401.7k, avg=3D1423.58, stdev=3D38712=
.03=0A=
=A0=A0=A0 clat (usec): min=3D60, max=3D2683.7k, avg=3D86310.45, stdev=3D289=
174.76=0A=
=A0=A0=A0=A0 lat (usec): min=3D70, max=3D2683.7k, avg=3D87730.40, stdev=3D2=
91369.20=0A=
=A0=A0=A0 clat percentiles (usec):=0A=
=A0=A0=A0=A0 |=A0 1.00th=3D[=A0=A0=A0 239],=A0 5.00th=3D[=A0=A0=A0 562], 10=
.00th=3D[=A0=A0=A0 717],=0A=
=A0=A0=A0=A0 | 20.00th=3D[=A0=A0=A0 816], 30.00th=3D[=A0=A0=A0 865], 40.00t=
h=3D[=A0=A0=A0 906],=0A=
=A0=A0=A0=A0 | 50.00th=3D[=A0=A0=A0 947], 60.00th=3D[=A0=A0=A0 988], 70.00t=
h=3D[=A0=A0 1057],=0A=
=A0=A0=A0=A0 | 80.00th=3D[=A0=A0 1156], 90.00th=3D[=A0=A0 2147], 95.00th=3D=
[ 935330],=0A=
=A0=A0=A0=A0 | 99.00th=3D[1266680], 99.50th=3D[1300235], 99.90th=3D[1350566=
],=0A=
=A0=A0=A0=A0 | 99.95th=3D[1384121], 99.99th=3D[1803551]=0A=
=A0=A0 bw (=A0 MiB/s): min=3D=A0 228, max=3D 3556, per=3D100.00%, avg=3D155=
3.73,=0A=
stdev=3D 2.08, samples=3D12469=0A=
=A0=A0 iops=A0=A0=A0=A0=A0=A0=A0 : min=3D58376, max=3D910489, avg=3D397711.=
45, stdev=3D532.63,=0A=
samples=3D12469=0A=
=0A=
Test results for write:=0A=
=A0write: IOPS=3D85.1k, BW=3D334MiB/s (350MB/s)(10.2GiB/31279msec); 0 zone =
resets=0A=
=A0=A0=A0 slat (usec): min=3D7, max=3D1397.5k, avg=3D1430.09, stdev=3D38675=
.97=0A=
=A0=A0=A0 clat (usec): min=3D14, max=3D2684.1k, avg=3D97398.93, stdev=3D306=
662.71=0A=
=A0=A0=A0=A0 lat (usec): min=3D28, max=3D2684.1k, avg=3D98825.72, stdev=3D3=
08705.23=0A=
=A0=A0=A0 clat percentiles (usec):=0A=
=A0=A0=A0=A0 |=A0 1.00th=3D[=A0=A0=A0 314],=A0 5.00th=3D[=A0=A0=A0 635], 10=
.00th=3D[=A0=A0=A0 717],=0A=
=A0=A0=A0=A0 | 20.00th=3D[=A0=A0=A0 791], 30.00th=3D[=A0=A0=A0 840], 40.00t=
h=3D[=A0=A0=A0 881],=0A=
=A0=A0=A0=A0 | 50.00th=3D[=A0=A0=A0 922], 60.00th=3D[=A0=A0=A0 971], 70.00t=
h=3D[=A0=A0 1057],=0A=
=A0=A0=A0=A0 | 80.00th=3D[=A0=A0 1270], 90.00th=3D[=A0 10290], 95.00th=3D[1=
044382],=0A=
=A0=A0=A0=A0 | 99.00th=3D[1266680], 99.50th=3D[1300235], 99.90th=3D[1350566=
],=0A=
=A0=A0=A0=A0 | 99.95th=3D[1384121], 99.99th=3D[1769997]=0A=
=A0=A0 bw (=A0 KiB/s): min=3D98765, max=3D1568174, per=3D100.00%, avg=3D681=
623.43,=0A=
stdev=3D924.60, samples=3D12469=0A=
=A0=A0 iops=A0=A0=A0=A0=A0=A0=A0 : min=3D24675, max=3D391998, avg=3D170363.=
71, stdev=3D231.14,=0A=
samples=3D12469=0A=
=0A=
=0A=
The FIO job:=0A=
[global]=0A=
name=3D4k random read 4 ios=0A=
ioengine=3Dlibaio=0A=
direct=3D1=0A=
readwrite=3Drandrw=0A=
rwmixread=3D70=0A=
iodepth=3D64=0A=
buffered=3D0=0A=
size=3D400M=0A=
runtime=3D30=0A=
time_based=0A=
randrepeat=3D0=0A=
norandommap=0A=
refill_buffers=0A=
ramp_time=3D10=0A=
bs=3D4k=0A=
numjobs=3D400=0A=
group_reporting=3D1=
