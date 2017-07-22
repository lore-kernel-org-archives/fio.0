Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:37054 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdGVBgQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2017 21:36:16 -0400
Received: by mail-ua0-f178.google.com with SMTP id f9so55433379uaf.4
        for <fio@vger.kernel.org>; Fri, 21 Jul 2017 18:36:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1466818EED73F47951D660798FA40@CY1PR0401MB1466.namprd04.prod.outlook.com>
References: <CY1PR0401MB1466818EED73F47951D660798FA40@CY1PR0401MB1466.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 22 Jul 2017 02:35:44 +0100
Message-ID: <CALjAwxjyxN0g2NQL06P69Pko5GCS=chk-S3m_GJtTenk0QobLg@mail.gmail.com>
Subject: Re: Number of Significant Figures
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jeff,

On 22 July 2017 at 00:09, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> In commit d694a6a7c02f577b2bb5d0ad24331b775acf6869 the reported IOPs chan=
ged from 6 significant figures to 4 significant figures.  So a fio summary =
file may change from 12345 IOPs to 12.3k IOPs.  The attached patch will res=
tore the original 6 significant figures (or maxlen in num2str.c).

Which output is this in relation to - normal, terse or json?

Note that if you're referring to normal then I'm afraid that output
format is not considered stable and can arbitrarily change (the
current change was made for compactness). The view is regular output
is meant for eyeballs and users should use the json (or less flexible
terse) output for machine parsing purposes. Now I look perhaps this
needs to be made more explicit in the documentation...

--=20
Sitsofe | http://sucs.org/~sits/
