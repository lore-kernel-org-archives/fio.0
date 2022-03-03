Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329BFC433F5
	for <fio@archiver.kernel.org>; Thu,  3 Mar 2022 15:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiCCPBS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Mar 2022 10:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbiCCPBR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Mar 2022 10:01:17 -0500
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2495711EF0D
        for <fio@vger.kernel.org>; Thu,  3 Mar 2022 07:00:30 -0800 (PST)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220303150026usoutp010b5ce06344ca20350a3a659ebf61cb74~Y5vo0hb2D2867528675usoutp01b;
        Thu,  3 Mar 2022 15:00:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220303150026usoutp010b5ce06344ca20350a3a659ebf61cb74~Y5vo0hb2D2867528675usoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646319626;
        bh=nu/lASKwMTXqt3pMroQ2ja4/1VUyiDPqiyo086X9WX4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=P6bpUxW+DuzQxxyVO1INETG0TjWFnNjtYQ1ySbUMO6fMBKlHTF0hpFNEhq1KiSuk3
         9Bkq3r9e6v7dEZUm+bT8eIHX4FYZIDnZEXsJA9l99E5lXjJztrlhzN0amCKqErebaH
         U0hPQhCo0lyvCtnar9Ez8Qb46XVANFNKu6H41KS8=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220303150025uscas1p2b9ec71c552015caa817c9f813ea48e6d~Y5vojyL_72360823608uscas1p2T;
        Thu,  3 Mar 2022 15:00:25 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 51.70.09687.908D0226; Thu, 
        3 Mar 2022 10:00:25 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220303150025uscas1p2e3f0bef66c6a3ce278d5c9bfe1557679~Y5voPSEMB2359523595uscas1p2e;
        Thu,  3 Mar 2022 15:00:25 +0000 (GMT)
X-AuditID: cbfec370-9c5ff700000025d7-a7-6220d8094810
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id E5.02.09657.908D0226; Thu, 
        3 Mar 2022 10:00:25 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Thu, 3 Mar 2022 07:00:24 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Thu, 3 Mar 2022 07:00:19 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Nick Neumann <nick@pcpartpicker.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: Not logging zero entry intervals when using --log_avg_msec
 seems problematic
Thread-Topic: Not logging zero entry intervals when using --log_avg_msec
        seems problematic
Thread-Index: AQHYKbojhU82Q8on2ESRbYxrCIopbaysavDggACi0gCAALrJAA==
Date:   Thu, 3 Mar 2022 15:00:19 +0000
Message-ID: <82afb384ca0a4dd591b3857e6089e7fe@samsung.com>
In-Reply-To: <CADqNVTqz-458F0T8dpFq=0R1eGnaCmYWgyf+eURhYhX2pVz8sw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djX87qcNxSSDJpX6Fl8nPWC2WLezt/s
        Dkwe5zcqenzeJBfAFMVlk5Kak1mWWqRvl8CVMefpTcaCLcIVR6deZG5g/CLUxcjJISFgIjH3
        713mLkYuDiGBlYwSbT+WskA4rUwSizoesMJUHdy1DcwWEljLKDHvjR5E0QdGiYM7NrBCOPsZ
        JZZ/vsrexcjBwSagKfF2fwGIKSKgIfHtNx9IL7OAvsSSC8dYQGxhgWiJdft7mUFsEYEYiS2P
        nrNA2E4S31oOMILYLAIqEueWLWAHsXkFrCReXvoJVs8pEChx9OwJsDijgJjE91NrmCDmi0vc
        ejKfCeJmQYlFs/cwQ9hiEv92PWSDsBUl7n9/CXYlM9CV63fpQ7QqSkzpfgi1SlDi5MwnLBDl
        khIHV9yAsjs5JA7N9YCwXSTudR9nhLClJaavuQwONwmByYwSX7fdZ4NwVjNKvFxwCarKWuJf
        5zV2iG18En9/PWKcwKg8C8ndsxBumoXkpllIblrAyLKKUby0uDg3PbXYOC+1XK84Mbe4NC9d
        Lzk/dxMjMGGc/ne4YAfjrVsf9Q4xMnEwHmKU4GBWEuG11FRIEuJNSaysSi3Kjy8qzUktPsQo
        zcGiJM67LHNDopBAemJJanZqakFqEUyWiYNTqoFpjdLFT04hpewnvm6TMy1lknTpPHTfRfJz
        76y48y5/NaeJmtm75mz9H1T8cxar5e461qkT/1av3SeuxJMc9Wem5Y9Y05ylXyqiw4L2Czzf
        d9C6lGGzhOcztqV6OsK9DA+5GJar5vnszbXg82o1POl0reDW4zUqxqVefDxuKcGM0R+0FzF3
        rX6/zmzuDdEzs4uu3rrR/mWWsYzBsSX20lV/jgo6ysasna3hfJ+tP7ZGITx5tefVGX+1ypW4
        UrcctZliWnMtv7BC81BuasHtyZ3M+xa+3xk8J3J5UeetB9sVTp5paHne0iJqLGkZcUzw9OqD
        e784zXKKtYv0qEtu2C34Pi7KKq1A8ucqk6fVM5RYijMSDbWYi4oTAdd43ACHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LJbGCaqMt5QyHJ4NwlUYuPs14wW8zb+Zvd
        gcnj/EZFj8+b5AKYorhsUlJzMstSi/TtErgy5jy9yViwRbji6NSLzA2MX4S6GDk5JARMJA7u
        2sYKYgsJrGaUOLeQG8L+wCgxpdGwi5ELyN7PKHHl1weWLkYODjYBTYm3+wtATBEBDYlvv/lA
        ypkF9CWWXDjGAmILC0RLTH42GWykiECMxIk186FsJ4lvLQcYQWwWARWJc8sWsIPYvAJWEi8v
        /WSGWDuHSeLWPUsQm1MgUOLo2RNgNYwCYhLfT61hgtglLnHryXwmiPMFJJbsOc8MYYtKvHz8
        jxXCVpS4//0lO8iZzEAXr9+lD9GqKDGl+yHUWkGJkzOfsECUS0ocXHGDZQKj+CwkG2YhdM9C
        0j0LSfcCRpZVjOKlxcW56RXFxnmp5XrFibnFpXnpesn5uZsYgfF0+t/hmB2M92591DvEyMTB
        eIhRgoNZSYTXUlMhSYg3JbGyKrUoP76oNCe1+BCjNAeLkjivR+zEeCGB9MSS1OzU1ILUIpgs
        EwenVAPThA1HqjSkKmc/m2uvmvS0iMWu0HfP+/+xudXnqv70/a5WVz1wlE8iuMfjqteer2VT
        Y6dbnpf7lH9AhFvvgmy/Wr3XAUGm31VRjsn+9tKvOMu3LTB4KWWuk60948Z/bdbCxMMXE3p4
        3004wSXNMb1h84JlBx0POsWYVvw5NFXI59iv9Hs7fL/fijp7e94BjR3tkd+ZElX2rF4uGz3L
        jVWisbTq/PINm6/Fvpr0yDRn45bQ5XM99pl6mCd8tgos2XRB4dT0tmfmi0X+6Em2qnl+nyA5
        ba/huZZHR4wTK2c6R6ZcSCh+tHLPRFWp+bunLl16T1NVKTIj9P25cN41824+OdRy7UhqrPDH
        G+ZzlU4ZKbEUZyQaajEXFScCAMQO7XAWAwAA
X-CMS-MailID: 20220303150025uscas1p2e3f0bef66c6a3ce278d5c9bfe1557679
CMS-TYPE: 301P
X-CMS-RootMailID: 20220224200742uscas1p144ff2f87331ec864d2aaac92459b0c44
References: <CGME20220224200742uscas1p144ff2f87331ec864d2aaac92459b0c44@uscas1p1.samsung.com>
        <CADqNVTqmWV8MiFZ6x8N4u8Poefxb9jRbpLkH03w7VPoFzEixUQ@mail.gmail.com>
        <dd8cee13d295483e9be4e1a375823a3a@samsung.com>
        <CADqNVTqz-458F0T8dpFq=0R1eGnaCmYWgyf+eURhYhX2pVz8sw@mail.gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaWNrIE5ldW1hbm4gW21haWx0
bzpuaWNrQHBjcGFydHBpY2tlci5jb21dDQo+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggMiwgMjAy
MiAyOjQyIFBNDQo+IFRvOiBWaW5jZW50IEZ1IDx2aW5jZW50LmZ1QHNhbXN1bmcuY29tPg0KPiBD
YzogZmlvQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogTm90IGxvZ2dpbmcgemVybyBl
bnRyeSBpbnRlcnZhbHMgd2hlbiB1c2luZyAtLWxvZ19hdmdfbXNlYw0KPiBzZWVtcyBwcm9ibGVt
YXRpYw0KPiANCi4uLg0KPiBUaGUgYmFuZHdpZHRoL2lvcHMgbG9nIHN0dWZmIGhhcyBvdGhlciBx
dWlya3MgdG9vLCBzb21lIG9mIHdoaWNoIEkndmUgcG9zdGVkDQo+IGFib3V0IGluIG90aGVyIG1h
aWxpbmdzIHRvIHRoaXMgbGlzdC4gVGhlIGNvZGUgZm9yIGJhbmR3aWR0aC9pb3BzIGxvZ2dpbmcN
Cj4gbGV2ZXJhZ2VzIHRoZSBsaXZlIHN0YXRpc3RpY3MgY29kZSwgd2hpbGUgdGhlIGNvZGUgZm9y
IGxhdGVuY3kgbG9nZ2luZyBpcyBkaXN0aW5jdC4NCj4gQXMgc3VjaCwgYncvaW9wcyBsb2dzIGhh
dmUgdGhlIGZvbGxvd2luZyBxdWlya3MsIGJ1dCBsYXRlbmN5IGxvZ3MgZG8gbm90Og0KPiAxKSBE
YXRhIGFmdGVyIHRoZSBsYXN0IGZ1bGwgaW50ZXJ2YWwgaXMgb21pdHRlZCAoZS5nLiBpZiB5b3Ug
dXNlIDMwMG1zIGludGVydmFsIGFuZA0KPiB5b3VyIGpvYiB0YWtlcyA1IHNlY29uZHMsIHRoZSBs
YXN0IDIwMCBtcyBpcyBub3QgaW4gdGhlIGxvZ3MpLiBUaGlzIHJlYWxseQ0KPiBzdXJwcmlzZWQg
bWUgYW5kIEkgZG9uJ3QgdGhpbmsgYW4gZW5kLXVzZXIgd291bGQgZXhwZWN0IHRoaXMuIEl0IG5l
dmVyDQo+IGhhcHBlbnMgd2l0aCBsYXRlbmN5IGxvZ3MuDQo+IDIpIExvZyBpbnRlcnZhbHMgYXJl
IG5vdCBjb25zaXN0ZW50bHkgc2l6ZWQgLSB0aGUgY29kZSBhaW1zIHRvIGhpdCB0aGUgc3BlY2lm
aWVkDQo+IGxvZ19pbnRlcnZhbF9tcywgYnV0IHlvdSBvZnRlbiBlbmQgdXAgd2l0aCBpbnRlcnZh
bHMgdGhhdCBhcmUgYmlnZ2VyL3NtYWxsZXIuDQo+IChUaGlzIGNhbiBoYXBwZW4gd2l0aCBsYXRl
bmN5IGxvZ3MsIGJ1dCBpcyBtdWNoIHJhcmVyIC0gb25seSB3aGVuIG9wZXJhdGlvbnMNCj4gYXJl
IG5vdCBoYXBwZW5pbmcgYXQgYSBub3JtYWwgcmF0ZS4pDQo+IA0KDQpoZWxwZXJfdGhyZWFkLmM6
aGVscGVyX3RocmVhZF9tYWluKCkgaGFuZGxlcyBsb2dnaW5nLCBzdGVhZHlzdGF0ZSwgc2lnbmFs
cywgc3RhdHVzX2ludGVydmFsLCBhbmQgZGlzayB1dGlsaXphdGlvbiBtZWFzdXJlbWVudHMuIElm
IG11bHRpcGxlIG9mIHRoZXNlIGZlYXR1cmVzIGFyZSBhY3RpdmUgdGhlbiB0aGVyZSBtYXkgYmUg
c21hbGwgZGV2aWF0aW9ucyBpbiB0aGUgbG9nZ2luZyB0aW1lIGludGVydmFscy4NCg0KRm9yIG1p
c3NpbmcgZmluYWwgbG9nIGVudHJpZXMsIHdoYXQgaGFwcGVucyBpcyB0aGF0IHRoZSBoZWxwZXIg
dGhyZWFkIHJlY2VpdmVzIGFuIGV4aXQgbm90aWZpY2F0aW9uIChBX0VYSVQpIGFuZCB0aGVuIHN0
b3BzIGNoZWNraW5nIGl0cyBvdGhlciByZXNwb25zaWJpbGl0aWVzLiBJdCB3b3VsZCBiZSByZWFz
b25hYmxlIHRvIG1ha2Ugb25lIGZpbmFsIGNhbGwgdG8gdGhlIGxvZ2dpbmcgY29kZSBiZWZvcmUg
ZXhpdGluZyB0aGUgaGVscGVyIHRocmVhZCBidXQgdGhlcmUgbWlnaHQgbmVlZCB0byBiZSBzb21l
IGd1YXJkcyB0byBtYWtlIHN1cmUgdGhlIGxvZ2dpbmcgY29kZSBkb2VzIG5vdCB0cnkgdG8gYWNj
ZXNzIHRocmVhZHMgdGhhdCBoYXZlIGFscmVhZHkgYmVlbiB0b3JuIGRvd24uDQo=
