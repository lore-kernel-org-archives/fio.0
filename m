Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-dm6nam11on2128.outbound.protection.outlook.com ([40.107.223.128]:13217
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbgD3GKR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Apr 2020 02:10:17 -0400
Subject: Re: Sequential read/write with multiple threads
References: <5ac69854-8385-6e5e-4a88-76f0880a6c6e@eafit.edu.co>
From: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Message-ID: <ccac042b-4011-d3c4-d79c-2b0d7e2798f9@eafit.edu.co>
Date: Thu, 30 Apr 2020 02:10:13 -0400
In-Reply-To: <5ac69854-8385-6e5e-4a88-76f0880a6c6e@eafit.edu.co>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi there,

Yes I saw it. Thank you very much for your help.

I finally got it to run by using the flags size and offset_increment. An 
example for future readers:

I'm trying to do sequential and random requests to the same file with 
multiple threads, preventing each thread to interfere in other thread's 
requests. My file size is 200G, then, if the number of threads is 4, I 
set the flag --size to 50G, that is, I divide the file size into the 
number of threads. Also, as offset_increment accepts a percentage, I 
divide 100% into the number of threads, in this case I set it to 25%. 
With these two flags each thread starts doing the specified requests 
adding 50G to the offset (because that's 25% percent of the file) and 
they only issue requests up to 50G, preventing an overflow to other 
thread's chunk or outside the file.

Even though it's working for me (it's not crashing, nor screwing the 
file), If I'm wrong in something please correct me.

Thank you.

Hamilton.

On 30/04/20 1:59 a. m., Sitsofe Wheeler wrote:
> On Wed, 29 Apr 2020 at 15:41, Hamilton Tobon Mosquera
> <htobonm@eafit.edu.co> wrote:
>> Hi there, I send this again, I'm not sure if it was sent last time, I
>> thought I was subscribed to the mailing list but I wasn't.
> Did you see my reply to your previous mail -
> https://nam01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Ffio%2Fmsg08483.html&amp;data=01%7C01%7Chtobonm%40eafit.edu.co%7C969ea7f7c9f64f8a377808d7eccbbcfd%7C99f7b55e9cbe467b8143919782918afb%7C0&amp;sdata=f7lIoMftni9kAlZu5j0TKfzjtByBt21lpm2BeOs0gF4%3D&amp;reserved=0 
> ?
>
>
> --
> Sitsofe | 
> https://nam01.safelinks.protection.outlook.com/?url=http:%2F%2Fsucs.org%2F~sits%2F&amp;data=01%7C01%7Chtobonm%40eafit.edu.co%7C969ea7f7c9f64f8a377808d7eccbbcfd%7C99f7b55e9cbe467b8143919782918afb%7C0&amp;sdata=JmGkoD6x%2F%2FF6Rh%2B9PvrQucHElsF8yIGlDcY3gcsiR4o%3D&amp;reserved=0
> La información contenida en este correo electrónico estádirigida 
> únicamente a su destinatario y puede contener información 
> confidencial, material privilegiado o información protegida porderecho 
> de autor. Está prohibida cualquier copia, utilización,indebida 
> retención, modificación, difusión, distribución o reproducción total o 
> parcial. Si usted recibe este mensaje por error, por favor contacte al 
> remitente y elimínelo. La información aquí contenida es 
> responsabilidad exclusiva de su remitente porlo tanto la Universidad 
> EAFIT no se hace responsable de lo que el mensaje contenga. The 
> information contained in this email is addressed to its recipient only 
> and may contain confidential information, privileged material or 
> information protected by copyright. Its prohibited any copy, use, 
> improper retention, modification, dissemination, distribution or total 
> or partial reproduction. If you receive this message by error, please 
> contact the sender and delete it. The information contained herein is 
> the sole responsibility of the sender therefore Universidad EAFIT is 
> not responsible for what the message contains.


