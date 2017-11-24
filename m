Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:46077 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdKXSln (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Nov 2017 13:41:43 -0500
Received: by mail-pg0-f43.google.com with SMTP id 207so15819313pgc.12
        for <fio@vger.kernel.org>; Fri, 24 Nov 2017 10:41:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgZdYXAMw7dB6yfCJi9ihj9YJ-M=YEb4ncYWO9PLwdOjg@mail.gmail.com>
References: <CAPqbHXh=+CXA1+Y0mmHbDmJauu53h6AmFNWW8ASWViP-LxKiEw@mail.gmail.com>
 <BN3PR0401MB145791EDDCE1E1F98FB2D4CD8F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAPqbHXj_N20pBvC3fvrsUS7eYH9oGRhhwmG4L6YZPrr=gdHMMA@mail.gmail.com> <CALjAwxgZdYXAMw7dB6yfCJi9ihj9YJ-M=YEb4ncYWO9PLwdOjg@mail.gmail.com>
From: Prabhakaran <prabhugce@gmail.com>
Date: Fri, 24 Nov 2017 11:41:42 -0700
Message-ID: <CAPqbHXjX8mpMRnuPKw7U1oHnx7DxXaQjayGiX_ux=G28w-RtJw@mail.gmail.com>
Subject: Re: Running for a specific number of IOs
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Sitsofe,

Your idea did work!!

Thanks,
Prabhu

On 22 November 2017 at 16:45, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> Try setting a large io_size (e.g. 1p) or a large number of loops
> alongside. See http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-io-size
> and http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-loops
> for documentation of those options.
>
> On 22 November 2017 at 23:35, Prabhakaran <prabhugce@gmail.com> wrote:
>> Hi Jeff,
>>
>> I wanted to generate ~1 billion IOs irrespective of runtime/size. I
>> think with your example, fio would break, if it reaches 'number_ios',
>> before it comes to end of first fill. With my example shown below, fio
>> exits after reaching size=100%, which I have not specified in my job
>> file.
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Thanks,
Prabhakaran
