import boto3,csv,logging,sys,datetime

#Function to list all Certificates
def list_acm_certificates(client,cert_list):
    #print("inside")
    response = client.list_certificates()
    #print(response)
    #print("inside")
    for item in response['CertificateSummaryList'] :
        print (item['CertificateArn'])
        cert_list.append(item['CertificateArn'])
    return(cert_list)
    

#Function to get Tags
def get_tags(client,CertificateArn):
    response = client.list_tags_for_certificate(CertificateArn = CertificateArn)
    tags= response['Tags']
    return tags


#Function to get Validation method
def get_validation_method(client,CertificateArn):
    response = client.describe_certificate(CertificateArn=CertificateArn)
    if response['Certificate']['Type'] == 'AMAZON_ISSUED' :
        ValidationMethod= response['Certificate']['DomainValidationOptions'][0]['ValidationMethod']
        return ValidationMethod
    else:
        return ("Validation Method can only be provided for AMAZON ISSUED CERTS")


#Function to write to csv file
def write_to_csv(filename,write_row):
    with open(filename, 'a') as f:
        # create the csv writer
        writer = csv.writer(f)

        # write a row to the csv file
        writer.writerow(write_row)


if __name__=="__main__":
    cert_list=[]
    write_row=[]
    
    region_name = sys.argv[1]
    # Create file name and add header to CSV
    filename='report'+ datetime.date.today().strftime('%d-%m-%Y') +region_name+'.csv'
    write_row.append("Certificate ARN")
    write_row.append("TAGS")
    write_row.append("VALIDATION METHOD")
    write_to_csv(filename,write_row)

    # Create a boto3 client
    client = boto3.client('acm',region_name=region_name)
    #fetch certificateARN from certificate list
    cert_list=list_acm_certificates(client,cert_list)
    if len(cert_list) == 0:
        row=["No Certificate In This Region"]
        write_to_csv(filename,row)
    for cert in cert_list:
        write_row=[]
        write_row.append(cert)
        #fetch tags for certificate
        tags = get_tags(client,cert)
        #fetch validate methods for certificate
        ValidationMethod = get_validation_method(client,cert)
        # Create a row which can be appended to CSV
        write_row.append(str(tags))
        write_row.append(ValidationMethod)
        write_to_csv(filename,write_row)

    print("Report file with the ACM Details has been generated")