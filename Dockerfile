ARG TERRAGRUNT_VERSION=v0.17.3
ARG TERRAFORM_VERSION=0.11.11

FROM golang:1 as terragrunt
ARG TERRAGRUNT_VERSION
ARG TERRAFORM_VERSION
RUN echo "Terragrunt: $TERRAGRUNT_VERSION"
RUN echo "Terraform: $TERRAFORM_VERSION"
RUN go get github.com/gruntwork-io/terragrunt
RUN cd src/github.com/gruntwork-io/terragrunt && git checkout $TERRAGRUNT_VERSION
RUN CGO_ENABLED=0 GOOS=linux go install -a -ldflags "-extldflags \"-static\" -X main.VERSION=$TERRAGRUNT_VERSION" github.com/gruntwork-io/terragrunt

FROM hashicorp/terraform:$TERRAFORM_VERSION
RUN apk add libc6-compat
COPY --from=terragrunt /go/bin/terragrunt /bin
ENTRYPOINT ["/bin/terragrunt"]
