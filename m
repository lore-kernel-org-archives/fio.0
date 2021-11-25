Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF083C433F5
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 15:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhKYPYi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbhKYPWh (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 10:22:37 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CDBC06179B
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 07:18:08 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b40so17123943lfv.10
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 07:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=WHulag4GWCGFDjYG6z1DyriGebEm715uxu+XC56OiHs=;
        b=KY6pxr6hDSr4wTNJXgzIu3pKLV5c8uvMtXuCNXIOwRhlMJySkJ+7EixvHLhc/+30EU
         5ZH48UuNamjlueAzsvRdEbl8LlvIm1v5TXsugFhWge6YFv8+1vJwVwThAGRnTapet8Wl
         nlA00TT6NFREuQhoMe3aeG/K0kB+q2073PnAAoNXwQ8G9TBzZT76c2JsrbFGkb1vrCaU
         0b/HEznjp0EHOvlAf3HJq9h4JjmiAYWuCqIfGP2+biIn70LfdGDq87ULdsdOD7Xn9og7
         +/fou7c7o2jk++z+4XhLGKkceOYSljYl4y0o+kHOiepE/VIgAP27ytP0JFnJrkO7PZ0X
         Acfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=WHulag4GWCGFDjYG6z1DyriGebEm715uxu+XC56OiHs=;
        b=uJOgxrUAg37/0Xh7eRiODETHNbdQfcXyb/s90FIXQjttiLYt+EUrZDvgbqkwf8qDeD
         bhMuAz9CFU6WsSMdgklcgfoaLHftaoyaTlQ6g0HV/gpTxYX/65xNlFICX2t8e4JGS/ah
         QOZqWi9QLfGA4BCNBMGj7kMqCCLBPPpYH8d0zc3+HGhPYcUrooIFOP1hC+Fms5doa8IE
         y3W3D759+0vqKhcWyzhBH2ZayfYfdw1Pmw0JjTRMGH0XWKCS1O67bQjyMyLGhb7O+0gD
         EamRHylOX5+lxjFKl6vBZPlZPNKm2RrLWrwc6XzP/xvL4JosZA9GAggsZA2jjDGglYiD
         aZcQ==
X-Gm-Message-State: AOAM5314ggKSedpVZTF47vsoSoldHzbIeWBFslQ6Yi7lMe9t2SaBO8E7
        P1VRKbFpzS+COKb+xHRv+4Uj04U21XigmA==
X-Google-Smtp-Source: ABdhPJwfwRSFiHAFBuQdXE2BU7cxsuX1xyHO9yYdUCBsxdqKfjYYjqI6JJzqPkUprDnjSP5xVf4y+w==
X-Received: by 2002:a05:6512:138a:: with SMTP id p10mr5885509lfa.508.1637853486537;
        Thu, 25 Nov 2021 07:18:06 -0800 (PST)
Received: from [192.168.222.110] ([37.139.80.10])
        by smtp.gmail.com with ESMTPSA id i17sm286588lfp.99.2021.11.25.07.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:18:06 -0800 (PST)
Message-ID: <44a99ee0-4856-51eb-0172-9d635582223e@cloudlinux.com>
Date:   Thu, 25 Nov 2021 18:18:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Seyed Mohammad Fakhraie <fk.smoh@gmail.com>
Cc:     fio@vger.kernel.org
References: <CACzyWQx0YZgwyJLRzBESL-8EoLzWzyFrqWMsVb0hs1Z-K7TMSA@mail.gmail.com>
 <d3c7a9ca-af7e-9d70-f229-74558d17cfe2@cloudlinux.com>
 <CACzyWQzih6gCQ4vYGA9Hwj-Zq4_d+YKC1j=secP8W9nr7bZCgg@mail.gmail.com>
From:   Dmitry Antipov <dantipov@cloudlinux.com>
Subject: Re: Using FIO to benchmark Gluster
In-Reply-To: <CACzyWQzih6gCQ4vYGA9Hwj-Zq4_d+YKC1j=secP8W9nr7bZCgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gMTEvMjUvMjEgMTc6NTMsIFNleWVkIE1vaGFtbWFkIEZha2hyYWllIHdyb3RlOg0KDQo+
ICrCoFRoZSBvdXRwdXQgb2Yg4oCNJ2dsdXN0ZXIgdm9sdW1lIGluZm8nIGlzIGFzIGZvbGxv
d3M6DQo+IA0KPiAqVm9sdW1lIE5hbWU6IGd2MA0KPiBUeXBlOiBEaXN0cmlidXRlZC1SZXBs
aWNhdGUNCj4gVm9sdW1lIElEOiA3NTk0NmEzZS1mNjcwLTRmNTgtYTYxZS1jM2M2MWUzZDk3
N2QNCj4gU3RhdHVzOiBTdGFydGVkDQo+IFNuYXBzaG90IENvdW50OiAwDQo+IE51bWJlciBv
ZiBCcmlja3M6IDUgeCAoMiArIDEpID0gMTUNCj4gVHJhbnNwb3J0LXR5cGU6IHRjcA0KPiBC
cmlja3M6DQo+IEJyaWNrMTogc3RvcmFnZS1ub2RlMDovZGF0YS9icmljazAvZ3YwDQo+IEJy
aWNrMjogc3RvcmFnZS1ub2RlMTovZGF0YS9icmljazAvZ3YwDQo+IEJyaWNrMzogc3RvcmFn
ZS1ub2RlMjovZGF0YS9hcmJpdDAvZ3YwIChhcmJpdGVyKQ0KPiBCcmljazQ6IHN0b3JhZ2Ut
bm9kZTM6L2RhdGEvYnJpY2swL2d2MA0KPiBCcmljazU6IHN0b3JhZ2Utbm9kZTQ6L2RhdGEv
YnJpY2swL2d2MA0KPiBCcmljazY6IHN0b3JhZ2Utbm9kZTA6L2RhdGEvYXJiaXQwL2d2MCAo
YXJiaXRlcikNCj4gQnJpY2s3OiBzdG9yYWdlLW5vZGUxOi9kYXRhL2JyaWNrMS9ndjANCj4g
QnJpY2s4OiBzdG9yYWdlLW5vZGUyOi9kYXRhL2JyaWNrMC9ndjANCj4gQnJpY2s5OiBzdG9y
YWdlLW5vZGUzOi9kYXRhL2FyYml0MC9ndjAgKGFyYml0ZXIpDQo+IEJyaWNrMTA6IHN0b3Jh
Z2Utbm9kZTQ6L2RhdGEvYnJpY2sxL2d2MA0KPiBCcmljazExOiBzdG9yYWdlLW5vZGUwOi9k
YXRhL2JyaWNrMS9ndjANCj4gQnJpY2sxMjogc3RvcmFnZS1ub2RlMTovZGF0YS9hcmJpdDAv
Z3YwIChhcmJpdGVyKQ0KPiBCcmljazEzOiBzdG9yYWdlLW5vZGUyOi9kYXRhL2JyaWNrMS9n
djANCj4gQnJpY2sxNDogc3RvcmFnZS1ub2RlMzovZGF0YS9icmljazEvZ3YwDQo+IEJyaWNr
MTU6IHN0b3JhZ2Utbm9kZTQ6L2RhdGEvYXJiaXQwL2d2MCAoYXJiaXRlcikNCj4gT3B0aW9u
cyBSZWNvbmZpZ3VyZWQ6DQo+IHBlcmZvcm1hbmNlLmNsaWVudC1pby10aHJlYWRzOiBvZmYN
Cj4gbmZzLmRpc2FibGU6IG9uDQo+IHRyYW5zcG9ydC5hZGRyZXNzLWZhbWlseTogaW5ldOKA
jeKAjeKAjQ0KDQpUbyB0cmFjayBkb3duIGFuIGlzc3VlLCBJIHdvdWxkIHJlY29tbWVuZCB0
byB0cnkgdG8gcmVwcm9kdWNlDQppdCBvbiB0aGUgdmVyeSBiYXNpYyByZXBsaWNhdGVkIHZv
bHVtZSBmaXJzdC4gSXQgaXMgaW1wb3J0YW50DQp0byBoYXZlIGFsbCBvZiB0aGUgYnJpY2tz
IG9uIHRoZSBzYW1lIGhvc3QsIGUuZy46DQoNClZvbHVtZSBOYW1lOiB0ZXN0MA0KVHlwZTog
UmVwbGljYXRlDQpWb2x1bWUgSUQ6IGE3MWY5MGExLTQxMzYtNGM4Ny1iZmM1LTE4YjFkYTQ3
Nzg2NA0KU3RhdHVzOiBTdGFydGVkDQpTbmFwc2hvdCBDb3VudDogMA0KTnVtYmVyIG9mIEJy
aWNrczogMSB4IDMgPSAzDQpUcmFuc3BvcnQtdHlwZTogdGNwDQpCcmlja3M6DQpCcmljazE6
IG5vZGUwOi9wb29sLzAgICAgICAgICAgICAgICAgOzsgc2FtZSBob3N0DQpCcmljazI6IG5v
ZGUwOi9wb29sLzEgICAgICAgICAgICAgICAgOzsgc2FtZSBob3N0DQpCcmljazM6IG5vZGUw
Oi9wb29sLzIgICAgICAgICAgICAgICAgOzsgc2FtZSBob3N0DQpPcHRpb25zIFJlY29uZmln
dXJlZDoNCmNsdXN0ZXIuZ3JhbnVsYXItZW50cnktaGVhbDogb24NCnN0b3JhZ2UuZmlwcy1t
b2RlLXJjaGVja3N1bTogb24NCnRyYW5zcG9ydC5hZGRyZXNzLWZhbWlseTogaW5ldA0KbmZz
LmRpc2FibGU6IG9uDQpwZXJmb3JtYW5jZS5jbGllbnQtaW8tdGhyZWFkczogb2ZmDQoNCkFs
c28gbGltaXQgeW91ciAnZmlvJyB3b3JrbG9hZCB0byAnbnVtam9icz0xJy4NCg0KRmluYWxs
eSB5b3UgZm9yZ290IHRvIG1lbnRpb24gR2x1c3RlckZTIHZlcnNpb24geW91J3JlIHVzaW5n
Lg0KDQpEbWl0cnkNCg==
