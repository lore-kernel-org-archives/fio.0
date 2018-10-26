Return-Path: <fio-owner@vger.kernel.org>
Received: from esa8.dell-outbound.iphmx.com ([68.232.149.218]:20055 "EHLO
        esa8.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbeJZTjC (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 26 Oct 2018 15:39:02 -0400
Received: from pps.filterd (m0133268.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9QAm2o0130339
        for <fio@vger.kernel.org>; Fri, 26 Oct 2018 07:02:23 -0400
Received: from esa3.dell-outbound2.iphmx.com (esa3.dell-outbound2.iphmx.com [68.232.154.63])
        by mx0a-00154901.pphosted.com with ESMTP id 2n7xksk43s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Fri, 26 Oct 2018 07:02:22 -0400
From: "Beierl, Mark" <Mark.Beierl@dell.com>
Subject: Re: Static linking and RDB/Rados
Date: Fri, 26 Oct 2018 11:02:01 +0000
Message-ID: <7D6A87DE-8A24-4E68-B750-78D7B2294DC6@emc.com>
References: <3AF0240C-DE31-4E79-AB21-31D04B863142@emc.com>,<CALjAwxjS4MXpf_K6mqE2vb=+sJ40iVgKQyLJ0zfEyR2JEBpfAQ@mail.gmail.com>
In-Reply-To: <CALjAwxjS4MXpf_K6mqE2vb=+sJ40iVgKQyLJ0zfEyR2JEBpfAQ@mail.gmail.com>
Content-Language: en-CA
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>



> On Oct 26, 2018, at 00:12, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>=20
>=20
> [EXTERNAL EMAIL]=20
> Please report any suspicious attachments, links, or requests for sensitiv=
e information.
>=20
>=20
> Hi,
>=20
>> On Fri, 26 Oct 2018 at 00:53, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>>=20
>> I=92ve been doing some playing around with static linking and from the l=
ooks of it the static libraries for Rados and RDB are no longer available. =
 Same goes for some of the libraries needed to enable HTTP (S3) support.
>>=20
>> So, I don=92t think the options for =96build-static are valid anymore.  =
If anyone has pointers as to how to get the static Rados or RDB libraries, =
I=92d love to hear about it :)
>=20
> You didn't mention your distro but I think in the case of curl (which
> is used for the HTTP/S3 suport) it will be highly environment
> dependent. For example, Ubuntu seem to ship a static version of
> libcurl (https://packages.ubuntu.com/bionic/amd64/libcurl4-gnutls-dev/fil=
elist
> and see libcurl-gnutls.a) but I can't see any static libcurl in
> regular Fedora packages. In fact, I know that Fedora doesn't ship a
> static libaio either and others have been forced to download the
> source, build a private copy with a static library and then point fio
> at that in they wanted such a binary on Fedora.
> --=20
> Sitsofe | http://sucs.org/~sits/

Thanks, Sitsofe.=20

Sorry about that. I tried Alpine, Ubuntu 16.04 and 18.04, as well as CentOS=
 7. No luck with any of them. It also seems that I was going down some rabb=
it hole with nghttp2, which also seems to be missing the .a static library.=
 I think most distros are moving away from shipping static libraries now.=20

My goal is to create a statically linked FIO that I can use on different ta=
rgets without having to recompile on each. I=92m no longer sure that this i=
s even a good thing, because if the distro maintainers are dropping static =
libraries, there must be a good reason.=20

Having said that, if I do get a docker build with all the static sources an=
d a final FIO statically built, would the community be interested in this? =
 I could propose a patch with this as a dockerfile if so and then others wi=
th experience in different areas might be able to help. =

