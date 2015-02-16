Return-Path: <fio-owner@vger.kernel.org>
Received: from server506l.appriver.com ([50.56.144.158]:61903 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753552AbbBPSA6 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 16 Feb 2015 13:00:58 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: [Suggestion] Header for --minimal output
Date: Mon, 16 Feb 2015 17:50:56 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB10940A12@DAGN05C-E6.exg6.exghost.com>
References: <CAB-428kQh_D2T4tT7AoP3Gmt=Q4=Z32h7PLwM2fugDwuDFNr=A@mail.gmail.com>,<CALjAwxjYy7j9=+Hfh-jS_MiSV2OPatXn1_YAdsUrbQmPkDiHUw@mail.gmail.com>
In-Reply-To: <CALjAwxjYy7j9=+Hfh-jS_MiSV2OPatXn1_YAdsUrbQmPkDiHUw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

(sorry about the top-posting)

Not always, there are many applications where columnar data is easier to work with; I have a fair number of processes that collect lots of fio terse output and use awk & sort to condense the results. JSON would add an extra set of steps.

That aside, an optional fio-provided header would be nice.

z!

________________________________________
From: fio-owner@vger.kernel.org [fio-owner@vger.kernel.org] on behalf of Sitsofe Wheeler [sitsofe@gmail.com]
Sent: Monday, February 16, 2015 9:30 AM
To: Alireza Haghdoost
Cc: fio@vger.kernel.org
Subject: Re: [Suggestion] Header for --minimal output

On 16 February 2015 at 16:34, Alireza Haghdoost <haghdoost@gmail.com> wrote:
> the --minimal output is very hard to track and decode by script

Wouldn't it be preferable to use the json output if things are going
to be processed further?
