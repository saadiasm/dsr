function [theta fit_flag] = fitEllipse(reg)
        [th_fit_e]=fit_ellipse(reg(:,2), reg(:,1));
        if (isempty(th_fit_e) || isempty(th_fit_e.a))
            theta = -1;
            fit_flag=false;
        else
            fit_flag = true;
            theta(2) = th_fit_e.X0_in;
            theta(1) = th_fit_e.Y0_in;
            theta(3) = th_fit_e.phi;
            theta(5) = th_fit_e.a;
            theta(4) = th_fit_e.b;
        end
end