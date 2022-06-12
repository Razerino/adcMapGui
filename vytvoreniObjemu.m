clc, clear all, close all
tic
%% Nacteni DCM snimku a vytvoreni objemu rezu o stejne hodnote bVal
%napoveda - ulozitJako4D
%prepinace - 'ano' --> ulozeni vsech objemu ruznych hodnot b value do 4D
%          - 'ne' --> ulozeni vsech objemu ruznych hodnot b value zvlast
%data jsou ulozeny do slozky, ze ktere byly nacteny DICOM snimky

%napoveda - nacteniMozek
%prepinace - 'ano' --> jsou nacitany MRI snimky mozku
%          - 'ne' --> jsou nacitani MRI snimky prostaty
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ulozitJako4D = 'ne'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% <-- PRED SPUSTENIM NUTNO NASTAVIT!
nacteniMozek = 'ano'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% <-- PRED SPUSTENIM NUTNO NASTAVIT!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nacteniMozek
    case 'ano'
        cesta = uigetdir();                                              %vyber slozky s DCM daty
        cestaIma = [cesta, '\*.IMA'];                                    %vytvoreni cesty

        vyber = dir(cestaIma);                                           %cesta k souborum
        pocet = numel(vyber);                                            %pocet souboru

        %vytvoreni ID pro kazdy rez
        for l = 1:pocet
            cestaSouboru = [vyber(l).folder, '\', vyber(l).name];
            [vyber(l).data] = dicomread(cestaSouboru);                   %nacteni obrazovych dat
            info = dicominfo(cestaSouboru);                              %nacteni DICOM tagu

            %ulozeni DICOM tagu pro pozdejsi ulozeni
            if strcmp(info.(dicomlookup('0018', '0024')),'*ep_b0')
                b0Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b50t')
                b50Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b100t')
                b100Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b150t')
                b150Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b200t')
                b200Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b500t')
                b500Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b1000t')
                b1000Info = info;
            end
            [vyber(l).seq] = info.(dicomlookup('0018', '0024'));         %ulozeni typu sekvence do struktury
        end

        %vytvoreni objemu - spojeni rezu
        m = 1; n = 1; o = 1; p = 1; q = 1; r = 1; s = 1; t = 1;          %promenne pro kodovani rezu

        for l = 1:pocet
            if strcmp(vyber(l).seq,'*ep_b0')
                noDiff(:,:,m) = vyber(l).data;
                m = m+1;
            elseif contains(vyber(l).seq,'*ep_b50t')
                b50Data(:,:,n) = vyber(l).data;
                n = n+1;
            elseif contains(vyber(l).seq,'*ep_b100t')
                b100Data(:,:,o) = vyber(l).data;
                o = o+1;
            elseif contains(vyber(l).seq,'*ep_b150t')
                b150Data(:,:,p) = vyber(l).data;
                p = p+1;
            elseif contains(vyber(l).seq,'*ep_b200t')
                b200Data(:,:,q) = vyber(l).data;
                q = q+1;
            elseif contains(vyber(l).seq,'*ep_b500t')
                b500Data(:,:,r) = vyber(l).data;
                r = r+1;
            elseif contains(vyber(l).seq,'*ep_b1000t')
                b1000Data(:,:,s) = vyber(l).data;
                s = s+1;
            elseif contains(vyber(l).seq, '*ep_b0_1000')
                adcMapaSiemens(:,:,t) = vyber(l).data;
                t = t+1;
            end
        end

% Otoceni kazdeho rezu - nepouzito, dochazi k vymene rovin a uprava
% aplikace je komplikovana. Vyreseno otocenim ukladaneho objemu ADC mapy
%         for k = 1:size(adcMapaSiemens,3)
%             adcMapaSiemens(:,:,k) = imrotate(adcMapaSiemens(:,:,k),270);
%         end
%         for k = 1:size(noDiff,3)
%             noDiff(:,:,k) = imrotate(noDiff(:,:,k),270);
%         end
%         for k = 1:size(b50Data,3)
%             b50Data(:,:,k) = imrotate(b50Data(:,:,k),270);
%         end
%         for k = 1:size(b100Data,3)
%             b100Data(:,:,k) = imrotate(b100Data(:,:,k),270);
%         end
%         for k = 1:size(b150Data,3)
%             b150Data(:,:,k) = imrotate(b150Data(:,:,k),270);
%         end
%         for k = 1:size(b200Data,3)
%             b200Data(:,:,k) = imrotate(b200Data(:,:,k),270);
%         end
%         for k = 1:size(b500Data,3)
%             b500Data(:,:,k) = imrotate(b500Data(:,:,k),270);
%         end
%         for k = 1:size(b1000Data,3)
%             b1000Data(:,:,k) = imrotate(b1000Data(:,:,k),270);
%         end
        b400Data = [];
        clear info k l m n o p q r s t
      
    case 'ne'
        cesta = uigetdir();                                              %vyber slozky s DCM daty
        cestaIma = [cesta, '\*.IMA'];                                    %vytvoreni cesty

        vyber = dir(cestaIma);                                           %cesta k souborum
        pocet = numel(vyber);                                            %pocet souboru

        %vytvoreni ID pro kazdy rez
        for l = 1:pocet
            cestaSouboru = [vyber(l).folder, '\', vyber(l).name];
            [vyber(l).data] = dicomread(cestaSouboru);
            info = dicominfo(cestaSouboru);                              %nacteni DICOM tagu

            %ulozeni DICOM tagu pro pozdejsi ulozeni
            if strcmp(info.(dicomlookup('0018', '0024')),'*ep_b0')
                b0Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b50t')
                b50Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b100t')
                b100Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b150t')
                b150Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b200t')
                b200Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b400t')
                b400Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')),'*ep_b800t')
                b800Info = info;
            elseif strcmp(info.(dicomlookup('0018', '0024')), '*ep_b1400t')
                b1400Info = info;
            end
            [vyber(l).seq] = info.(dicomlookup('0018', '0024'));         %ulozeni typu sekvence do struktury
        end
        
        %vytvoreni objemu - spojeni rezu
        m = 1; n = 1; o = 1; p = 1; q = 1; r = 1; s = 1; t = 1; u = 1;   %promenne pro kodovani rezu

        for l = 1:pocet
            if strcmp(vyber(l).seq,'*ep_b0')
                noDiff(:,:,m) = vyber(l).data;
                m = m+1;
            elseif contains(vyber(l).seq,'*ep_b50t')
                b50Data(:,:,n) = vyber(l).data;
                n = n+1;
            elseif contains(vyber(l).seq,'*ep_b100t')
                b100Data(:,:,o) = vyber(l).data;
                o = o+1;
            elseif contains(vyber(l).seq,'*ep_b150t')
                b150Data(:,:,p) = vyber(l).data;
                p = p+1;
            elseif contains(vyber(l).seq,'*ep_b200t')
                b200Data(:,:,q) = vyber(l).data;
                q = q+1;
            elseif contains(vyber(l).seq,'*ep_b400t')
                b400Data(:,:,r) = vyber(l).data;
                r = r+1;
            elseif contains(vyber(l).seq,'*ep_b800t')
                b800Data(:,:,s) = vyber(l).data;
                s = s+1;
            elseif contains(vyber(l).seq,'*ep_b1400t')
                b1400Data(:,:,t) = vyber(l).data;
                t = t+1;
            elseif contains(vyber(l).seq, '*ep_b0_1400')
                adcMapaSiemens(:,:,u) = vyber(l).data;
                u = u+1;
            end
        end

% Otoceni kazdeho rezu - nepouzito, byl by potreba menit kod aplikace
%         for k = 1:size(adcMapaSiemens,3)
%             adcMapaSiemens(:,:,k) = imrotate(adcMapaSiemens(:,:,k),270);
%         end
%         for k = 1:size(noDiff,3)
%             noDiff(:,:,k) = imrotate(noDiff(:,:,k),270);
%         end
%         for k = 1:size(b50Data,3)
%             b50Data(:,:,k) = imrotate(b50Data(:,:,k),270);
%         end
%         for k = 1:size(b100Data,3)
%             b100Data(:,:,k) = imrotate(b100Data(:,:,k),270);
%         end
%         for k = 1:size(b150Data,3)
%             b150Data(:,:,k) = imrotate(b150Data(:,:,k),270);
%         end
%         for k = 1:size(b200Data,3)
%             b200Data(:,:,k) = imrotate(b200Data(:,:,k),270);
%         end
%         for k = 1:size(b400Data,3)
%             b400Data(:,:,k) = imrotate(b400Data(:,:,k),270);
%         end
%         for k = 1:size(b800Data,3)
%             b800Data(:,:,k) = imrotate(b800Data(:,:,k),270);
%         end
%         for k = 1:size(b1400Data,3)
%             b1400Data(:,:,k) = imrotate(b1400Data(:,:,k),270);
%         end
        clear info k l m n o p q r s t u
end

%% Ukladani
if isempty(b400Data)
    switch ulozitJako4D
        case 'ano'
            dwiData4D = cat(4,b50Data,b100Data,b150Data,b200Data,b500Data,b1000Data);
            cesta4D = [cesta, '\dwiData4D.nii'];
            cestab0 = [cesta, '\b0Data.nii'];
            niftiwrite(dwiData4D,cesta4D)
            niftiwrite(noDiff, cestab0);
        case 'ne'
            cesta1 = [cesta, '\b0Data.nii'];
            niftiwrite(noDiff,cesta1)
            cesta2 = [cesta, '\b50Data.nii'];
            niftiwrite(b50Data,cesta2)
            cesta3 = [cesta, '\b100Data.nii'];
            niftiwrite(b100Data,cesta3)
            cesta4 = [cesta, '\b150Data.nii'];
            niftiwrite(b150Data,cesta4)
            cesta5 = [cesta, '\b200Data.nii'];
            niftiwrite(b200Data,cesta5)
            cesta6 = [cesta, '\b500Data.nii'];
            niftiwrite(b500Data,cesta6)
            cesta7 = [cesta, '\b1000Data.nii'];
            niftiwrite(b1000Data,cesta7)
            cesta8 = [cesta, '\AdcMapaSiemens.nii'];
            niftiwrite(adcMapaSiemens, cesta8)
    end
else
    switch ulozitJako4D
        case 'ano'
            dwiData4D = cat(4,b50Data,b100Data,b150Data,b200Data,b400Data,b800Data,b1400Data);
            cesta4D = [cesta, '\dwiData4D.nii'];
            cestab0 = [cesta, '\b0Data.nii'];
            niftiwrite(dwiData4D,cesta4D)
            niftiwrite(noDiff, cestab0);
        case 'ne'
            cesta1 = [cesta, '\b0Data.nii'];
            niftiwrite(noDiff,cesta1)
            cesta2 = [cesta, '\b50Data.nii'];
            niftiwrite(b50Data,cesta2)
            cesta3 = [cesta, '\b100Data.nii'];
            niftiwrite(b100Data,cesta3)
            cesta4 = [cesta, '\b150Data.nii'];
            niftiwrite(b150Data,cesta4)
            cesta5 = [cesta, '\b200Data.nii'];
            niftiwrite(b200Data,cesta5)
            cesta6 = [cesta, '\b400Data.nii'];
            niftiwrite(b400Data,cesta6)
            cesta7 = [cesta, '\b800Data.nii'];
            niftiwrite(b800Data,cesta7)
            cesta8 = [cesta, '\b1400Data.nii'];
            niftiwrite(b1400Data,cesta8);
            cesta9 = [cesta, '\AdcMapaSiemens.nii'];
            niftiwrite(adcMapaSiemens, cesta9)
    end
end
toc
