Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am1lp0011.outbound.protection.outlook.com ([213.199.154.11]:57381
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751191AbaCLRC1 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 12 Mar 2014 13:02:27 -0400
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= 
	<sbouchex@infovista.com>
Subject: RE: Bug with "multi directory support" on windows
Date: Wed, 12 Mar 2014 17:02:24 +0000
Message-ID: <1aa4558be83244eab90a5a4bbd323eb1@DB4PR03MB572.eurprd03.prod.outlook.com>
References: <e54fd34a63624f1ca306d3a6970272ac@DB4PR03MB572.eurprd03.prod.outlook.com>
 <53208C3D.8000500@kernel.dk>
 <53aec4da21c24553af5648e726474b17@DB4PR03MB572.eurprd03.prod.outlook.com>
 <53208F72.4040404@kernel.dk>
In-Reply-To: <53208F72.4040404@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Ah ok, the example is linux oriented, that's why I did not see it.

Thanks
Seb

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jens Axboe
Sent: mercredi 12 mars 2014 17:47
To: S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD; fio@vger.kernel.org
Subject: Re: Bug with "multi directory support" on windows

On 03/12/2014 10:39 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> Escaping the directory worked : C\:\temp\fio\read
>
> Documentation update ?

I think so. It's documented under the 'filename' option, so we can just ref=
erence that. The directory option is right above it.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html
