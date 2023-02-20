import path, { dirname } from 'path'
import { fileURLToPath } from 'url';
import fs from 'fs'
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export const getCCPJsonFile = async(orgname) => {
    let ccpPath;
    switch(orgname){
        case 'Org1': ccpPath = path.resolve(__dirname,'..','config','connection-org1.json')
                break;
        case 'Org2': ccpPath = path.resolve(__dirname,'..','config','connection-org2.json')
                break;
        default: 
                return null; break;
    }
    const ccpJson = fs.readFileSync(ccpPath,'utf-8')
    const ccp = JSON.parse(ccpJson)
    return ccp;
}

export const getCaUrl = async(org,ccp) => {
    let caUrl;
    switch(org){
        
        case 'Org1': caUrl = ccp.certificateAuthorities['ca.org1.example.com'].url;
                break;
        case 'Org2': caUrl = ccp.certificateAuthorities['ca.org2.example.com'].url;
                break; 
        default: 
                return null; break;
    }
    return caUrl;
}
export const getCaInfo = async(org,ccp) => {
    let caInfo;
    switch(org){
        
        case 'Org1': caInfo = ccp.certificateAuthorities['ca.org1.example.com'];
                break;
        case 'Org2': caInfo = ccp.certificateAuthorities['ca.org2.example.com'];
                break;
        default: 
                return null; break;
    }
    return caInfo;
}
export const getWalletPath = async(org) => {
    let walletPath;
    switch(org){
        case 'Org1': walletPath = path.join(process.cwd(),'org1-wallet')
                break;
        case 'Org2': walletPath = path.join(process.cwd(),'org2-wallet')
                break;
        default: 
                return null; break;
    }
    return walletPath;
}