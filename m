Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38820 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdFAHUw (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Jun 2017 03:20:52 -0400
Received: by mail-it0-f53.google.com with SMTP id r63so26038570itc.1
        for <fio@vger.kernel.org>; Thu, 01 Jun 2017 00:20:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGjEAhu9xnC4rbAyc60gb8UNfecy=S+D3UmG+1vqQsuCFqaxiA@mail.gmail.com>
References: <CAGjEAhu9xnC4rbAyc60gb8UNfecy=S+D3UmG+1vqQsuCFqaxiA@mail.gmail.com>
From: qingwei wei <tchengwee@gmail.com>
Date: Thu, 1 Jun 2017 15:20:51 +0800
Message-ID: <CAGjEAhvxrjvs_WZXOozXRK9yAGa0S63Gw8BNtFW6_pqzVLHoig@mail.gmail.com>
Subject: Re: fio zipfian random_distribution offset selection
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I did a trial run (small data set size of 400KB) with iolog enable so
to capture the offset. From what i can see, the offset is indeed
randomly selected.

occurrence | offset
     10   16384
      1    45056
     13   77824
      4   110592
      2   139264
     47   172032
      5   204800
      1   233472
      1   266240
     11  299008
      2   331776
      3   393216

Do correct me if i am wrong.

Cw

On Tue, May 30, 2017 at 2:46 PM, qingwei wei <tchengwee@gmail.com> wrote:
> Hi,
>
> I would like to validate my understanding on fio zipfian
> random_distribution. Form my understanding, a zipfian 1.2 means ~95%
> of IO access will be concentrated on 5% offset location (Do correct me
> if i am wrong). So if i have a file with 100 offsets, i cold have
> offset 1, offset 5, offset 20, offset 86, offset 99 get repeatedly
> access. So my question is, is this offset being chosen randomly? Or is
> it possible to specify based on spatial locality, where nearby offset
> tend to be accessed together? Thanks.
>
> Cw
