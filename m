Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF41C433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 22:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiEWW4m (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 18:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiEWW4W (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 18:56:22 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB84EBE0F
        for <fio@vger.kernel.org>; Mon, 23 May 2022 15:56:18 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220523225614usoutp02d4bb507c92506efb2547d53b6a4bb541~x3fMvmo3-1933019330usoutp021;
        Mon, 23 May 2022 22:56:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220523225614usoutp02d4bb507c92506efb2547d53b6a4bb541~x3fMvmo3-1933019330usoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653346574;
        bh=5ZvQvHNovkqcv72qVu+syokzgwUVKR/yjDlbJMv/vVw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Phfn2KW6Jwe47rKv91eHtg1Hp4Ueu6I4+uaPC/NM77h5ZdAX7klCj7Y5iPDR07ZVk
         VxAjm4GwjUyI2Uy0dnzO3c+/32nNSykg3POOSZ9kNKqblUVUdtImumac8mBpUpAug2
         6/tDyd9zs0SSRFumckROZ8ioFgtyK/jrhpYGCHaE=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523225614uscas1p21ca4c617679fadaec72a854ca4c8d54c~x3fMpmULe3140231402uscas1p2S;
        Mon, 23 May 2022 22:56:14 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 68.0D.09749.E011C826; Mon,
        23 May 2022 18:56:14 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523225614uscas1p24eb9ec9c92d1998a05126a6a1014282b~x3fMXkFIf0412204122uscas1p2-;
        Mon, 23 May 2022 22:56:14 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-10-628c110e524e
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 9E.10.52349.E011C826; Mon,
        23 May 2022 18:56:14 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 23 May 2022 15:56:13 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        23 May 2022 15:56:13 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH 5/6] mem: try to parse /proc/meminfo to get huge page
 size
Thread-Topic: [PATCH 5/6] mem: try to parse /proc/meminfo to get huge page
        size
Thread-Index: AQHYbs6Hmcsriz4iOkKkJvgIZCyMC60tOSyA//+oKDA=
Date:   Mon, 23 May 2022 22:56:13 +0000
Message-ID: <a018febe94404c5ba4005e29c88c5902@samsung.com>
In-Reply-To: <3aeda4fc-4ea5-3dda-12c8-ed95403f9862@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWy7djXc7p8gj1JBm/+qFisvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKuHOli7XgBn/Fn0fHWBoYl/B3MXJySAiYSHw+
        tIGxi5GLQ0hgJaPEpldT2CGcViaJ43M+McJU7Tv/CapqLaPEm6mvmEASQgKfGCXWf+WESCxj
        lNj/6Q9bFyMHB5uApsTb/QUgNSIC/hITXr1iBbGFBQIkVjxoYgQpEREIlPh+mxmixEric+sT
        sJEsAqoSjX9ugNm8QPFdu1+ygJRzCthKtF4CO4dRQEzi+6k1YCXMAuISt57MZ4I4U1Bi0ew9
        zBC2mMS/XQ/ZIGxFifvfX7KDjGEGOmz9Ln2IVkWJKd0P2SE2CUqcnPmEBaJcUuLgihssIE9J
        CPxll5g6vwXsYgkBF4lfU+0haqQlrl6fygxR084oMXfjF6jmCYwS159IQdjWEv86r7FDLOOT
        +PvrEdQcXomONqEJjEqzkHwwC+G6WUium4XkugWMLKsYxUuLi3PTU4uN81LL9YoTc4tL89L1
        kvNzNzECU8Xpf4cLdjDeuvVR7xAjEwfjIUYJDmYlEd7tiR1JQrwpiZVVqUX58UWlOanFhxil
        OViUxHmXZW5IFBJITyxJzU5NLUgtgskycXBKNTCZtchM0Hn478KdUxqXaies3r6rJNpg0Q3f
        UzXHvPdE9l+qn6c3o+Q519+zu7Zl7OtLOGVksfT+1TmZM55+PSLJfXXxlGD9umQ7DQ/NqxnO
        MhPKjitXS+kx7TnFUON90nR+ka2TxHaBnqqT7q0u3g+fsyfwMakmq77dt95iZuz7Sr3qKfeu
        ewdnrZKovnFWyVuw8pzZcQ9hTSX72013Nlxym6//cLOfzQ1f3vTF9ctWBfjFyH1d9Gxa/ro9
        eQ5+S89VpQvJLeJedjbwVX5r/tPGmQ8MfP9GXbXofNnXeepW+b/fvz2n1/ww5tmaozBJRcXD
        86Hvxc02W/PE6103KO1ubNnQxGSYY1RRU7HAjVWJpTgj0VCLuag4EQBuOTl8hAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWS2cA0SZdPsCfJYNJnAYvVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZd650sRbc4K/48+gYSwPjEv4uRk4OCQETiX3n
        PzF2MXJxCAmsZpRYNGMWO4TziVFi3+ZeVghnGaPEof4nLF2MHBxsApoSb/cXgHSLCPhKHP68
        iR3EFhbwk/j/ZyMjRDxQYtGLncwQtpXE59YnTCA2i4CqROOfG2A2L1B81+6XLBDzvzFK7Ngw
        hxlkPqeArUTrJbA5jAJiEt9PrQGrZxYQl7j1ZD4TxNUCEkv2nGeGsEUlXj7+xwphK0rc//6S
        HWQMM9CZ63fpQ7QqSkzpfsgOsVZQ4uRMkE9AyiUlDq64wTKBUWwWkg2zELpnIemehaR7ASPL
        Kkbx0uLi3PSKYsO81HK94sTc4tK8dL3k/NxNjMDoOf3vcOQOxqO3PuodYmTiYDzEKMHBrCTC
        uz2xI0mINyWxsiq1KD++qDQntfgQozQHi5I4r5DrxHghgfTEktTs1NSC1CKYLBMHp1QDk767
        TO8x61De3/9unI8vCN4d5DtZTDvvcN6rpgCFqUxXnJJNrTpsN169p6kvJzCNwaBIqfm/S9SO
        36q+e0vyH+1MdVq4ck7ix1sGTiWL3dPsCqR8gsoyXCquxE/8pMhwi4njy/vw7V+MtGoKJI5n
        xLa3/wn/P+GKkY8cc0v0ubZJtxat5nAw36e4s/ziV/H7bQsllRo37Jpmyrd26ZatlZYcf9d7
        GQh9TMoq+Xxy75ndguw+jQudwm2+hJ1Vkz8i3/svVS4pcsWhJZ9fm26w/DVzxqHsj18eZVtd
        Vl2i/O5QAatFfn3IjKbLcj2/eX/vNi5uVXeXeF4wJVO9M1a04nQoe7Vafs25DOenF98rsRRn
        JBpqMRcVJwIA1PeIGw0DAAA=
X-CMS-MailID: 20220523225614uscas1p24eb9ec9c92d1998a05126a6a1014282b
CMS-TYPE: 301P
X-CMS-RootMailID: 20220523175713uscas1p1e0e247cd89c13bf395863183f07cd1e1
References: <20220523175650.130895-1-vincent.fu@samsung.com>
        <CGME20220523175713uscas1p1e0e247cd89c13bf395863183f07cd1e1@uscas1p1.samsung.com>
        <20220523175650.130895-6-vincent.fu@samsung.com>
        <3aeda4fc-4ea5-3dda-12c8-ed95403f9862@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKZW5zIEF4Ym9lIFttYWlsdG86
YXhib2VAa2VybmVsLmRrXQ0KPiBTZW50OiBNb25kYXksIE1heSAyMywgMjAyMiAyOjEzIFBNDQo+
IFRvOiBWaW5jZW50IEZ1IDx2aW5jZW50LmZ1QHNhbXN1bmcuY29tPjsgZmlvQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDUvNl0gbWVtOiB0cnkgdG8gcGFyc2UgL3Byb2Mv
bWVtaW5mbyB0byBnZXQgaHVnZQ0KPiBwYWdlIHNpemUNCj4gDQo+IE9uIDUvMjMvMjIgMTE6NTcg
QU0sIFZpbmNlbnQgRnUgd3JvdGU6DQo+ID4gSW5zdGVhZCBvZiByZWx5aW5nIG9uIGEgcGxhdGZv
cm0tc3BlY2lmaWMgZGVmYXVsdCBodWdlIHBhZ2Ugc2l6ZSwgdHJ5IHRvDQo+ID4gcGFyc2UgL3By
b2MvbWVtaW5mbyB0byBnZXQgdGhlIGh1Z2UgcGFnZSBzaXplIHdoZW4gaXQgaXMgbm90IGV4cGxp
Y2l0bHkNCj4gPiBzcGVjaWZpZWQgYXMgYW4gb3B0aW9uLg0KPiANCj4gSXQncyByZWFsbHkgc2Fk
IHRoYXQgdGhlcmUgaXNuJ3QgYSBuaWNlIHdheSB0byBnZXQgdGhpcyBpbmZvcm1hdGlvbiwgYnV0
DQo+IHBhcnNpbmcgbWVtaW5mbyB3aWxsIG9ubHkgZ2V0IHlvdSBvbmUgb2YgdGhlbS4gRWcgb24g
bXkgbGFwdG9wOg0KPiANCj4gYXhib2VAbTEgfj4gY2F0IC9wcm9jL21lbWluZm8gfCBncmVwIC1p
IHNpemUNCj4gSHVnZXBhZ2VzaXplOiAgICAgIDMyNzY4IGtCDQo+IA0KPiBCdXQgaWYgeW91IGxv
b2sgaW46DQo+IA0KPiBheGJvZUBtMSB+PiBscyAvc3lzL2tlcm5lbC9tbS9odWdlcGFnZXMvDQo+
IGh1Z2VwYWdlcy0xMDQ4NTc2a0IvICBodWdlcGFnZXMtMjA0OGtCLyAgaHVnZXBhZ2VzLTMyNzY4
a0IvDQo+IA0KPiBhbmQgZWFjaCBkaXJlY3RvcnkgaGFzIGVudHJpZXMgZm9yIGluY3JlYXNpbmcg
dGhlIG51bWJlciBvZiB0aGVtIGFuZA0KPiBob3cNCj4gbWFueSBhcmUgY3VycmVudGx5IHRoZXJl
Lg0KPiANCj4gUGFyc2luZyAvc3lzL2tlcm5lbC9tbS9odWdlcGFnZXMvIGlzIHByb2JhYmx5IGEg
YmV0dGVyIGlkZWEgdGhhbg0KPiBtZW1pbmZvLg0KPiANCg0KTG9va2luZyBpbnRvIHRoaXMgbW9y
ZSwgaXQgc2VlbXMgdGhhdCB0byBkbyB0aGlzIDEwMCUgY29ycmVjdGx5IHdpbGwgdGFrZSBtb3Jl
DQp0aW1lIHRoYW4gSSBoYXZlLg0KDQpIb3dldmVyLCBJIHRoaW5rIHRoaXMgcGF0Y2ggaXMgc3Rp
bGwgYW4gaW1wcm92ZW1lbnQgb3ZlciBhIGJ1aWxkLXRpbWUgZGVmYXVsdC4NCkhvdyBhYm91dCBp
ZiBJIHJldmlzZSB0aGUgZG9jdW1lbnRhdGlvbiB0byBzYXkgdGhhdCBmaW8gd2lsbCBwYXJzZQ0K
L3Byb2MvbWVtaW5mbyAod2hpY2ggcmVwb3J0cyB0aGUgZGVmYXVsdCBodWdlIHBhZ2Ugc2l6ZSkg
YnV0IFlNTVYgYW5kIHVzZXJzDQpuZWVkIHRvIGV4cGxpY2l0bHkgc2V0IHRoZSBodWdlIHBhZ2Ug
c2l6ZSBpZiB0aGV5IGFyZSB1c2luZyBzb21ldGhpbmcgZWxzZT8NCg==
