Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37922 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdE3Gqt (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 May 2017 02:46:49 -0400
Received: by mail-it0-f51.google.com with SMTP id r63so36413031itc.1
        for <fio@vger.kernel.org>; Mon, 29 May 2017 23:46:48 -0700 (PDT)
MIME-Version: 1.0
From: qingwei wei <tchengwee@gmail.com>
Date: Tue, 30 May 2017 14:46:47 +0800
Message-ID: <CAGjEAhu9xnC4rbAyc60gb8UNfecy=S+D3UmG+1vqQsuCFqaxiA@mail.gmail.com>
Subject: fio zipfian random_distribution offset selection
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I would like to validate my understanding on fio zipfian
random_distribution. Form my understanding, a zipfian 1.2 means ~95%
of IO access will be concentrated on 5% offset location (Do correct me
if i am wrong). So if i have a file with 100 offsets, i cold have
offset 1, offset 5, offset 20, offset 86, offset 99 get repeatedly
access. So my question is, is this offset being chosen randomly? Or is
it possible to specify based on spatial locality, where nearby offset
tend to be accessed together? Thanks.

Cw
