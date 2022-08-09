Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF83BC19F2D
	for <fio@archiver.kernel.org>; Tue,  9 Aug 2022 13:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbiHINa5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Aug 2022 09:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiHINaz (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Aug 2022 09:30:55 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5B11FA
        for <fio@vger.kernel.org>; Tue,  9 Aug 2022 06:30:54 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220809133050usoutp01c6748adcc387636e301ba49fad37d986~JsFzqPNcS1137911379usoutp01V;
        Tue,  9 Aug 2022 13:30:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220809133050usoutp01c6748adcc387636e301ba49fad37d986~JsFzqPNcS1137911379usoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660051850;
        bh=tVKImqRGXqU4PZ2fbiHfGyLJ+NTDwB0MNrNE0+3sGz0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TCQ8L+yfyk42tBAZG2DRZSwHkJt+Ss0SBgJhr+S7/a1Xr1220S6dZPbufsYVuAG12
         cHbUxF2bproRd7G2EmNUZ2kfyJ59tdSBoEBLgY4WpzGnpBNoHeSlCUGfbYL5N+xE70
         39kPKAMiBrLS1kGRIkRfAvijN9q1PhdQb+bah43c=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220809133050uscas1p106826c60dcbce775aa356a9637d0566d~JsFzapEVr2562725627uscas1p1p;
        Tue,  9 Aug 2022 13:30:50 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 2F.EE.08540.A8162F26; Tue, 
        9 Aug 2022 09:30:50 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220809133050uscas1p155951e0c721230c3eeea50b1747e0ad3~JsFzHhKzZ2249922499uscas1p1P;
        Tue,  9 Aug 2022 13:30:50 +0000 (GMT)
X-AuditID: cbfec370-f13ff7000001215c-87-62f2618aaa23
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id DA.F1.52945.98162F26; Tue, 
        9 Aug 2022 09:30:50 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 9 Aug 2022 06:30:49 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        9 Aug 2022 06:30:49 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
 releases
Thread-Topic: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
        releases
Thread-Index: AQHYq0+ITAtLrBI/PEym6RyZ0BRk8q2nAWIA//+PogA=
Date:   Tue, 9 Aug 2022 13:30:49 +0000
Message-ID: <f77991f3144a45b9a3542769738cea3f@samsung.com>
In-Reply-To: <746d3789-1551-6649-e49e-2472954be751@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWy7djX87pdiZ+SDD6ukrZYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVsWXKH9aCT5IVx6cnNzDOkexi5OSQEDCRuLZl
        F0sXIxeHkMBKRon1NzawQTitTBKvZm1ngalqevEQqmoto8T5qffYIZyPjBJ/j52BcpYySrTt
        +8TcxcjBwSagKfF2fwFIt4iAv8SEV69YQWxhgWCJ5jt3WSHiIRJX1m9hgbCtJDpatjCB2CwC
        KhL/l55gB7F5geIPd19nBLE5BWwlfj7awAxiMwqISXw/tQasnllAXOLWk/lMEJcKSiyavYcZ
        whaT+LfrIRuErShx//tLdpDTmIFOW79LH6JVUWJK90OoVYISJ2c+gXpYUuLgihtgD0sI/GWX
        WNQHMocDyHGR2NQZCVEjLTF9zWWomnZGibkbv0A1T2CUuP5ECsK2lvjXeY0dYhmfxN9fjxgh
        5vBKdLQJTWBUmoXkg1kI181Cct0sJNctYGRZxSheWlycm55abJyXWq5XnJhbXJqXrpecn7uJ
        EZguTv87XLCD8datj3qHGJk4GA8xSnAwK4nwHln7PkmINyWxsiq1KD++qDQntfgQozQHi5I4
        77LMDYlCAumJJanZqakFqUUwWSYOTqkGpkPXLhul2ut9vj25RmfGH8aMrmldC5q0JPYLvz82
        /zTPljZjBtl/3Z8eGP+uWXJJRcSV2bBp+4Z8DfMmpWzf2jy+d9M3uD0NW3Nszgl15wuT3hRL
        3Uv/5aJ+O9b5+p9jzz1Fr7NXlDxe/E9h12m7HqFPVo6dFe89I306899M/vReL/hJ0smr+o4Z
        fDO/7FNs0bFd0B1ys3/5x9gI3+vdnTyhHa9UPr3azKt5/KwFl2eQDHfUg6ub5yqvmhlQwKHG
        ZtL74M+vu+u/Kd4QYPm1RsHmJCu/mqYH+/rJn45w2p1r4/J5V8MTdXfORMGFszrWis6RS3Oc
        ef9CKkfaXpuzIsmK989cl75xmUX8SFWXrRJLcUaioRZzUXEiAJo1W0uGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWS2cA0Ubcr8VOSwcbHrBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgytkz5w1rwSbLi+PTkBsY5kl2MnBwSAiYSTS8e
        snQxcnEICaxmlFh/qxvK+cgo8WDpFiYIZymjxJF5J4EcDg42AU2Jt/sLQLpFBHwlDn/exA5i
        CwsESzTfucsKUiIiECKx7r4PRImVREcLyBhODhYBFYn/S0+AlfMCxR/uvs4IMf4Qo8TLCTcY
        QRKcArYSPx9tYAaxGQXEJL6fWgPWzCwgLnHryXwmiKsFJJbsOc8MYYtKvHz8jxXCVpS4//0l
        O8gNzEBnrt+lD9GqKDGl+yHUXkGJkzOfsECUS0ocXHGDZQKj2CwkG2YhdM9C0j0LSfcCRpZV
        jOKlxcW56RXFxnmp5XrFibnFpXnpesn5uZsYgbFz+t/hmB2M92591DvEyMTBCPQgB7OSCO+R
        te+ThHhTEiurUovy44tKc1KLDzFKc7AoifN6xE6MFxJITyxJzU5NLUgtgskycXBKNTBtTCt9
        sE0ub8r1hDXh53klHiuvu1pYfjTgddXyVNsS651vj717X5esEGYpt3OKXobhihktLV0C1UYb
        jykLedtXf5Obu+ur9UFXj/Wv85ec/Lk96OfMlnUhSyQvVzl5XnuouPYG158bwXODrv6ZrmQT
        0aMzTcc0OSTCf7FqCPvqSD/P8EKL8k7VuYzx5Xfia80N7x15Ppdh2kauBYFP4mQ6OtPc/u68
        UHO7gE27596SNDvTzWtYfyf5dq2xsss6fKJtivSrjWaznoXfUzdUbm5uVU3bpya2detbe+e7
        Mjpux9cGLl30XTs1LT+4+9Yl/e0Pn63WjLQ8VtT435FVYq3D/mdLe2rS5z79I8a8apkSS3FG
        oqEWc1FxIgAj46YIDAMAAA==
X-CMS-MailID: 20220809133050uscas1p155951e0c721230c3eeea50b1747e0ad3
CMS-TYPE: 301P
X-CMS-RootMailID: 20220808175150uscas1p29cea1de374da02264662429884c9eedf
References: <CGME20220808175150uscas1p29cea1de374da02264662429884c9eedf@uscas1p2.samsung.com>
        <20220808175133.37920-1-vincent.fu@samsung.com>
        <746d3789-1551-6649-e49e-2472954be751@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKZW5zIEF4Ym9lIFttYWlsdG86
YXhib2VAa2VybmVsLmRrXQ0KPiBTZW50OiBUdWVzZGF5LCBBdWd1c3QgOSwgMjAyMiA5OjEwIEFN
DQo+IFRvOiBWaW5jZW50IEZ1IDx2aW5jZW50LmZ1QHNhbXN1bmcuY29tPjsgZmlvQHZnZXIua2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDAvMV0gY2k6IHVwbG9hZCB0YWdnZWQgQXBw
VmV5b3IgaW5zdGFsbGVycyBhcyBHaXRIdWINCj4gcmVsZWFzZXMNCj4gDQo+IE9uIDgvOC8yMiAx
MTo1MSBBTSwgVmluY2VudCBGdSB3cm90ZToNCj4gPiBKZW5zLCBoZXJlIGlzIGEgcGF0Y2ggdGhh
dCBzaG91bGQgYWxsb3cgQXBwVmV5b3IgdG8gdXBsb2FkIFdpbmRvd3MNCj4gPiBpbnN0YWxsZXJz
IGFzIEdpdEh1YiByZWxlYXNlcy4gVGhpcyB3aWxsIHJlcXVpcmUgeW91IHRvIGNoYW5nZSB0aGUN
Cj4gPiBhdXRoZW50aWNhdGlvbiBrZXkgaW4gdGhlIHBhdGNoIHRvIGdldCBpdCB3b3JraW5nLg0K
PiA+DQo+ID4gSGVyZSBhcmUgdGhlIHN0ZXBzOg0KPiA+DQo+ID4gLSBHbyB0bw0KPiBodHRwczov
L3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9wcm90ZWN0Mi5maXJlZXllLmNvbS92MS91cmw/
az1jOA0KPiAwZjI1ZjUtYTk4NDMwYzUtYzgwZWFlYmEtMDAwYmFiZmZhYTIzLQ0KPiAzZjA3NTM5
Njk3YTZkYTk2JnE9MSZlPTQ1ZjM2YjBkLTM1ZDItNGMyYS1hZWY5LQ0KPiA5MGUzMzczYzQyNzkm
dT1odHRwcyozQSoyRioyRmdpdGh1Yi5jb20qMkZzZXR0aW5ncyoyRnRva2Vuc19fO0pTDQo+IFVs
SlNVISFFd1Z6cUdvVEtCcXYtMERXQUpCbSFTSnl4MzdjLQ0KPiB1R3V5OU5wblY1X1p6YU5FT2FE
MUVmUU5qTG80ak9kSVF5MGY3V1ZnNERwQzZzT05ISkFROFpyOGxqDQo+IGVZOGNkQ0Y3RFJ5UTRE
SlBqciQgICBhbmQgZ2VuZXJhdGUgYSBHaXRIdWIgdG9rZW4NCj4gPiAgIHdpdGggcHVibGljX3Jl
cG8gc2NvcGUuDQo+ID4gLSBHbyB0bw0KPiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0
cHM6Ly9wcm90ZWN0Mi5maXJlZXllLmNvbS92MS91cmw/az0yZA0KPiA1YTdkYWQtNGNkMTY4OWQt
MmQ1YmY2ZTItMDAwYmFiZmZhYTIzLQ0KPiAzYTQzMTc1ZWUwMWNmMWZmJnE9MSZlPTQ1ZjM2YjBk
LTM1ZDItNGMyYS1hZWY5LQ0KPiA5MGUzMzczYzQyNzkmdT1odHRwcyozQSoyRioyRmNpLmFwcHZl
eW9yLmNvbSoyRnRvb2xzKjJGZW5jcnlwdF8NCj4gXztKU1VsSlNVISFFd1Z6cUdvVEtCcXYtMERX
QUpCbSFTSnl4MzdjLQ0KPiB1R3V5OU5wblY1X1p6YU5FT2FEMUVmUU5qTG80ak9kSVF5MGY3V1Zn
NERwQzZzT05ISkFROFpyOGxqDQo+IGVZOGNkQ0Y3RFJ5WXdzcmU2MiQgICAoYW5kIGxvZ2luKSBh
bmQgZW5jcnlwdA0KPiA+ICAgdGhlIEdpdEh1YiB0b2tlbiBmcm9tIHRoZSBwcmV2aW91cyBzdGVw
Lg0KPiA+IC0gUmVwbGFjZSB0aGUgdG9rZW4gaW4gdGhlIHBhdGNoICh1bmRlciBhdXRoX3Rva2Vu
OiBzZWN1cmU6KSB3aXRoIHRoZQ0KPiA+ICAgb25lIGZyb20gdGhlIHByZXZpb3VzIHN0ZXAuDQo+
ID4NCj4gPiBUbyB0ZXN0IHRoaXMsIHB1c2ggYSB0YWcgZm9yIGEgY29tbWl0IG9uIHRoZSBtYXN0
ZXIgYnJhbmNoIHRvIEdpdEh1Yg0KPiBhbmQNCj4gPiB3ZSBzaG91bGQgZW5kIHVwIHdpdGggYSBX
aW5kb3dzIGluc3RhbGxlciBhdA0KPiA+DQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19o
dHRwczovL3Byb3RlY3QyLmZpcmVleWUuY29tL3YxL3VybD9rPWIwDQo+IGI4NmMwMy1kMTMzNzkz
My1iMGI5ZTc0Yy0wMDBiYWJmZmFhMjMtDQo+IGYxNTg1OTRjODQxNjkwMTEmcT0xJmU9NDVmMzZi
MGQtMzVkMi00YzJhLWFlZjktDQo+IDkwZTMzNzNjNDI3OSZ1PWh0dHBzKjNBKjJGKjJGZ2l0aHVi
LmNvbSoyRmF4Ym9lKjJGZmlvKjJGcmVsZWFzZQ0KPiBzX187SlNVbEpTVWwhIUV3VnpxR29US0Jx
di0wRFdBSkJtIVNKeXgzN2MtDQo+IHVHdXk5TnBuVjVfWnphTkVPYUQxRWZRTmpMbzRqT2RJUXkw
ZjdXVmc0RHBDNnNPTkhKQVE4WnI4bGoNCj4gZVk4Y2RDRjdEUnlZZDlDZjd6JA0KPiANCj4gSSBh
cHBsaWVkIHRoZSBwYXRjaCBhbmQgdXBkYXRlZCB0aGUga2V5LCBhbmQgcHVzaGVkIGEgdGVzdCB0
YWcuIExldCdzDQo+IHNlZSBpZiB0aGlzIHdvcmtzIQ0KPiANCj4gLS0NCj4gSmVucyBBeGJvZQ0K
DQpKZW5zLCBpZiB5b3UgZG9uJ3Qgd2FudCB0byB3YWl0IHlvdSBjYW4ga2lsbCB0aGlzIGJ1aWxk
Og0KDQpodHRwczovL2NpLmFwcHZleW9yLmNvbS9wcm9qZWN0L2F4Ym9lL2Zpby9idWlsZHMvNDQ0
MTY0MTkNCg0KQW5kIHRoZW4gdGhpcyBvbmUgc2hvdWxkIChmaW5nZXJzIGNyb3NzZWQpIHB1c2gg
aW5zdGFsbGVycyB0byBHaXRIdWI6DQoNCmh0dHBzOi8vY2kuYXBwdmV5b3IuY29tL3Byb2plY3Qv
YXhib2UvZmlvL2J1aWxkcy80NDQxNjQyMA0K
