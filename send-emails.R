library("blastula")
library("readxl")
library("glue")


# read client list --------------------------------------------------------

clients <- read_xlsx("clients.xlsx")





# send an email to each client --------------------------------------------

for (i in seq_len(nrow(clients))) {

  client <- clients[i, ]

  # make the email
  email <- compose_email(
    body = md(glue(
      "Hi {client$first},

      Please find the attached document for your review.

      Best,

      David"
    ))
  )

  # add attachments
  email <- add_attachment(email, file = "assets/pdf-example.pdf")

  # send the email
  smtp_send(
    email,
    from = "david_kahle@baylor.edu",
    to = client$email,
    subject = glue("Document for {client$first} {client$last}"),
    credentials = creds_key("baylor")
  )

  message(glue("Sent to {client$first} {client$last} ({client$email})"))
}
